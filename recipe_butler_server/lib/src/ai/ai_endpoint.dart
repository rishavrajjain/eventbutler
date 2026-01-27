import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class AiEndpoint extends Endpoint {
  Future<ButlerSuggestion> suggest(
    Session session,
    String userKey,
    int listId,
    String prompt,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanView(session, userId, listId);

    final list = await ShoppingList.db.findById(session, listId);
    final listName = list?.name ?? 'Event';

    final openaiKey =
        session.serverpod.getPassword('OPENAI_API_KEY') ??
        Platform.environment['OPENAI_API_KEY'] ??
        '';
    if (openaiKey.isEmpty) {
      session.log('[ButlerAI] OPENAI_API_KEY missing', level: LogLevel.error);
      throw Exception('AI not configured — OPENAI_API_KEY missing');
    }

    session.log(
      '[ButlerAI] Using OpenAI for list="$listName"',
      level: LogLevel.debug,
    );
    return _callOpenAI(
      session: session,
      apiKey: openaiKey,
      listName: listName,
      prompt: prompt,
    );
  }

  Future<ButlerSuggestion> _callOpenAI({
    required Session session,
    required String apiKey,
    required String listName,
    required String prompt,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final instructions =
        '''
You are Butler, an elite event planning concierge trusted by top event organizers worldwide. You help people plan flawless events by suggesting exactly the right shopping items and reminders.

RULES:
- Reply as JSON ONLY. No markdown, no extra text.
- Keep the message concise (<=50 words) and only include high-value info.
- JSON keys: "message" (string, max 60 words, warm and helpful), "shopping" (array), "reminders" (array).
- shopping items: { "title": string (specific item name), "qty": string (e.g. "2 packs", "1 large"), "notes": string? (pro tip or brand suggestion) }.
- reminders: { "title": string (actionable task), "dueIso": ISO-8601 datetime in UTC, "item": string? (related shopping item) }.
- If the user asks for items, ALWAYS populate the shopping array with specific, practical items. Think like an experienced party planner.
- If timing/scheduling is relevant, include reminders with realistic due times.
- If nothing fits, return empty arrays.
- Current UTC time: $now

EVENT: "$listName"
USER REQUEST: "$prompt"
''';

    // Use Chat Completions API directly (most reliable).
    return _callChatCompletions(
      session: session,
      apiKey: apiKey,
      instructions: instructions,
    );
  }

  Future<ButlerSuggestion?> _callResponsesApi({
    required Session session,
    required String apiKey,
    required String instructions,
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/responses');
    final body = {
      'model': 'gpt-5-mini',
      'input': [
        {'role': 'system', 'content': instructions},
        {'role': 'user', 'content': 'Return only the JSON.'},
      ],
      'max_output_tokens': 600,
    };

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode == 429) {
      return ButlerSuggestion(
        message:
            'Butler is cooling down (OpenAI rate limit). Please retry in a minute.',
        shopping: const [],
        reminders: const [],
      );
    }

    // If Responses API rejects params (400 unsupported_parameter), fall back.
    if (resp.statusCode != 200) {
      final preview = resp.body.length > 500
          ? resp.body.substring(0, 500)
          : resp.body;
      session.log(
        '[ButlerAI] Responses error ${resp.statusCode} body=$preview',
        level: LogLevel.error,
      );
      return null;
    }

    final payloadText = _extractResponses(session, resp.body);
    if (payloadText == null) {
      session.log(
        '[ButlerAI] Responses output missing usable text; falling back to chat',
        level: LogLevel.error,
      );
      return null;
    }
    return _safeDecode(session, payloadText);
  }

  Future<ButlerSuggestion> _callChatCompletions({
    required Session session,
    required String apiKey,
    required String instructions,
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': instructions},
        {'role': 'user', 'content': 'Return only the JSON.'},
      ],
      'max_completion_tokens': 600,
    };

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode == 429) {
      return ButlerSuggestion(
        message:
            'Butler is cooling down (OpenAI rate limit). Please retry in a minute.',
        shopping: const [],
        reminders: const [],
      );
    }

    if (resp.statusCode != 200) {
      final preview = resp.body.length > 500
          ? resp.body.substring(0, 500)
          : resp.body;
      session.log(
        '[ButlerAI] ChatCompletions error ${resp.statusCode} body=$preview',
        level: LogLevel.error,
      );
      return ButlerSuggestion(
        message:
            'Butler had trouble talking to OpenAI (code ${resp.statusCode}). Please retry.',
        shopping: const [],
        reminders: const [],
      );
    }

    final payloadText = _extractOpenAI(resp.body);
    return _safeDecode(session, payloadText);
  }

  ButlerSuggestion _safeDecode(Session session, String payloadText) {
    try {
      return ButlerSuggestion.fromJson(
        jsonDecode(payloadText) as Map<String, dynamic>,
      );
    } on FormatException catch (e) {
      final preview = payloadText.length > 500
          ? payloadText.substring(0, 500)
          : payloadText;
      session.log(
        '[ButlerAI] JSON parse error: $e payload="$preview"',
        level: LogLevel.error,
      );
      return ButlerSuggestion(
        message: 'Butler hit a snag formatting ideas. Please retry.',
        shopping: const [],
        reminders: const [],
      );
    }
  }

  String? _extractResponses(Session session, String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    // Direct text key (observed in latest responses).
    final rootText = decoded['text'];
    if (rootText is String && rootText.trim().isNotEmpty) {
      return rootText.trim();
    }
    // Prefer output[0].content if present (current Responses schema).
    final output = decoded['output'] as List<dynamic>? ?? const [];
    if (output.isNotEmpty) {
      final first = output.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        // content may be String or List of blocks
        if (content is String && content.trim().isNotEmpty) {
          return content.trim();
        }
        if (content is List) {
          for (final block in content) {
            if (block is Map<String, dynamic>) {
              final text = block['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                return text.trim();
              }
              final nested = block['content'] as String?;
              if (nested != null && nested.trim().isNotEmpty)
                return nested.trim();
            } else if (block is String && block.trim().isNotEmpty) {
              return block.trim();
            }
          }
        }
      } else if (first is String && first.trim().isNotEmpty) {
        return first.trim();
      }
    }
    // Next, try output_text if provided.
    final outputText = decoded['output_text'] as String?;
    if (outputText != null && outputText.trim().isNotEmpty) {
      return outputText.trim();
    }
    session.log(
      '[ButlerAI] Responses output missing text keys=${decoded.keys.toList()}',
      level: LogLevel.error,
    );
    return null;
  }

  String _extractOpenAI(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('AI missing choices');
    }
    final msg = choices.first['message'] as Map<String, dynamic>?;
    var text = msg?['content'] as String? ?? '';
    final fenceStart = text.indexOf('```json');
    if (fenceStart != -1) {
      final fenceEnd = text.indexOf('```', fenceStart + 6);
      if (fenceEnd != -1) {
        text = text.substring(fenceStart + 7, fenceEnd).trim();
      }
    }
    return text.trim();
  }

  String _requireUser(String userKey) {
    if (userKey.isEmpty) {
      throw sp.AccessDeniedException(message: 'Missing user identity');
    }
    return userKey;
  }

  Future<void> _assertCanView(
    Session session,
    String userId,
    int listId,
  ) async {
    final list = await ShoppingList.db.findById(session, listId);
    if (list == null) {
      throw sp.AccessDeniedException(message: 'Not found');
    }
    if (list.ownerUserId == userId) return;
    final member = await ShoppingListMember.db.findFirstRow(
      session,
      where: (m) => m.shoppingListId.equals(listId) & m.userId.equals(userId),
    );
    if (member == null) {
      throw sp.AccessDeniedException(message: 'No access');
    }
  }
}
