import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_butler_client/recipe_butler_client.dart';

import 'serverpod_client_service.dart';

const _localOpenaiKey =
    String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

class ButlerService {
  ButlerService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Client get _client => _clientService.client;

  Future<ButlerSuggestion> suggest(
    String userKey,
    int listId,
    String prompt, {
    String? listName,
  }) {
    return _client.ai.suggest(userKey, listId, prompt).catchError(
      (error) async {
        if (_localOpenaiKey.isNotEmpty) {
          debugPrint('[Butler] Falling back to local OpenAI: $error');
          return _suggestWithLocalOpenAI(
            listName: listName ?? 'Event',
            userPrompt: prompt,
          );
        }
        throw error;
      },
    );
  }

  Future<ButlerSuggestion> _suggestWithLocalOpenAI({
    required String listName,
    required String userPrompt,
  }) async {
    if (_localOpenaiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY missing. Pass --dart-define=OPENAI_API_KEY='
          'YOUR_KEY when running flutter.');
    }

    final now = DateTime.now().toUtc().toIso8601String();
    final instructions = '''
You are Butler, an elite event planning concierge. Help people plan flawless events by suggesting shopping items and reminders.

RULES:
- Reply as JSON ONLY. No markdown, no extra text.
- Keep the message concise (<=50 words) and only include high-value info.
- JSON keys: "message" (string, max 60 words), "shopping" (array), "reminders" (array).
- shopping items: { "title": string, "qty": string, "notes": string? }.
- reminders: { "title": string, "dueIso": ISO-8601 UTC, "item": string? }.
- ALWAYS populate shopping array with specific, practical items when asked. Think like an experienced party planner.
- If nothing fits, return empty arrays.
- Current UTC time: $now

EVENT: "$listName"
USER: "$userPrompt"
''';

    // Try Responses API first for newer models; fall back to chat completions.
    final responsesUri = Uri.parse('https://api.openai.com/v1/responses');
    final responsesBody = {
      'model': 'gpt-5-mini',
      'input': [
        {'role': 'system', 'content': instructions},
        {'role': 'user', 'content': 'Return only the JSON.'},
      ],
      'max_output_tokens': 600,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_localOpenaiKey',
    };

    final resp = await http.post(
      responsesUri,
      headers: headers,
      body: jsonEncode(responsesBody),
    );

    if (resp.statusCode == 429) {
      return ButlerSuggestion(
        message:
            'Butler is cooling down (OpenAI rate limit). Please retry in a minute.',
        shopping: const [],
        reminders: const [],
      );
    }

    if (resp.statusCode == 200) {
      try {
        final payloadText = _extractResponses(resp.body);
        if (payloadText != null) {
          return ButlerSuggestion.fromJson(
            jsonDecode(payloadText) as Map<String, dynamic>,
          );
        }
      } catch (_) {
        // fall through to chat completions
      }
    }

    // Fallback: chat completions with correct token field.
    final ccUri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final ccBody = {
      'model': 'gpt-5-mini',
      'messages': [
        {'role': 'system', 'content': instructions},
        {'role': 'user', 'content': 'Return only the JSON.'},
      ],
      'max_completion_tokens': 600,
    };

    final ccResp = await http.post(
      ccUri,
      headers: headers,
      body: jsonEncode(ccBody),
    );

    if (ccResp.statusCode == 429) {
      return ButlerSuggestion(
        message:
            'Butler is cooling down (OpenAI rate limit). Please retry in a minute.',
        shopping: const [],
        reminders: const [],
      );
    }

    if (ccResp.statusCode != 200) {
      return ButlerSuggestion(
        message:
            'Butler had trouble talking to OpenAI (code ${ccResp.statusCode}). Please retry.',
        shopping: const [],
        reminders: const [],
      );
    }

    final payloadText = _extractOpenAI(ccResp.body);
    return ButlerSuggestion.fromJson(
      jsonDecode(payloadText) as Map<String, dynamic>,
    );
  }

  String? _extractResponses(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final rootText = decoded['text'];
    if (rootText is String && rootText.trim().isNotEmpty) {
      return rootText.trim();
    }
    final output = decoded['output'] as List<dynamic>? ?? const [];
    if (output.isNotEmpty) {
      final first = output.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        if (content is String && content.trim().isNotEmpty) {
          return content.trim();
        }
        if (content is List) {
          for (final block in content) {
            if (block is Map<String, dynamic>) {
              final text = block['text'] as String?;
              if (text != null && text.trim().isNotEmpty) return text.trim();
              final nested = block['content'] as String?;
              if (nested != null && nested.trim().isNotEmpty) {
                return nested.trim();
              }
            } else if (block is String && block.trim().isNotEmpty) {
              return block.trim();
            }
          }
        }
      } else if (first is String && first.trim().isNotEmpty) {
        return first.trim();
      }
    }
    final outputText = decoded['output_text'] as String?;
    if (outputText != null && outputText.trim().isNotEmpty) {
      return outputText.trim();
    }
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
}
