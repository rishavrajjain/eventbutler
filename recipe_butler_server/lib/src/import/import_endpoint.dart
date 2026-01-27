import 'dart:convert';
import 'dart:math';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ImportEndpoint extends Endpoint {
  Future<Recipe> importRecipeFromUrl(
    Session session,
    String userKey,
    String url,
  ) async {
    final ownerUserId = _requireUser(userKey);
    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      throw sp.AccessDeniedException(message: 'Invalid URL');
    }

    final html = await _fetchHtml(uri);
    final parsed = html_parser.parse(html);

    final jsonLdRecipe = _extractJsonLdRecipe(parsed);
    final title = jsonLdRecipe.title ?? _fallbackTitle(parsed) ?? uri.host;
    final ingredients = jsonLdRecipe.ingredients.isNotEmpty
        ? jsonLdRecipe.ingredients
        : _fallbackIngredients(parsed);
    final steps = jsonLdRecipe.steps.isNotEmpty
        ? jsonLdRecipe.steps
        : _fallbackSteps(parsed);

    // Persist recipe and parts
    final recipe = await Recipe.db.insertRow(
      session,
      Recipe(
        title: title,
        ownerUserId: ownerUserId,
        sourceUrl: url,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    if (ingredients.isNotEmpty) {
      await Ingredient.db.insert(
        session,
        ingredients.map((text) {
          return Ingredient(recipeId: recipe.id!, text: text);
        }).toList(),
      );
    }

    if (steps.isNotEmpty) {
      await RecipeStep.db.insert(
        session,
        steps
            .asMap()
            .entries
            .map(
              (e) => RecipeStep(
                recipeId: recipe.id!,
                orderIndex: e.key,
                text: e.value,
              ),
            )
            .toList(),
      );
    }

    return recipe;
  }

  Future<String> _fetchHtml(Uri uri) async {
    const timeout = Duration(seconds: 8);
    final userAgents = _userAgents;
    final ua = userAgents[Random().nextInt(userAgents.length)];

    final response = await http
        .get(
          uri,
          headers: {
            'User-Agent': ua,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.9',
          },
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw sp.AccessDeniedException(
        message: 'Could not fetch page (${response.statusCode})',
      );
    }

    final body = response.body;
    if (body.length > 1024 * 1024 * 2) {
      throw sp.AccessDeniedException(message: 'Page too large');
    }
    return body;
  }

  _JsonLdRecipe _extractJsonLdRecipe(dom.Document doc) {
    final scripts = doc.querySelectorAll('script[type="application/ld+json"]');
    for (final script in scripts) {
      final content = script.text.trim();
      if (content.isEmpty) continue;
      try {
        final json = jsonDecode(content);
        final recipeNode = _findRecipeNode(json);
        if (recipeNode == null) continue;
        final title = recipeNode['name'] as String?;
        final ingredients = <String>[];
        final ingredientField = recipeNode['recipeIngredient'];
        if (ingredientField is List) {
          ingredients.addAll(ingredientField.map((e) => '$e').map(_cleanText));
        }
        final steps = <String>[];
        final recipeInstructions = recipeNode['recipeInstructions'];
        if (recipeInstructions is List) {
          for (final inst in recipeInstructions) {
            if (inst is Map && inst['text'] != null) {
              steps.add(_cleanText('${inst['text']}'));
            } else {
              steps.add(_cleanText('$inst'));
            }
          }
        } else if (recipeInstructions is String) {
          steps.add(_cleanText(recipeInstructions));
        }
        return _JsonLdRecipe(
          title: title,
          ingredients: ingredients,
          steps: steps,
        );
      } catch (_) {
        continue;
      }
    }
    return const _JsonLdRecipe();
  }

  Map<String, dynamic>? _findRecipeNode(dynamic json) {
    if (json is Map<String, dynamic>) {
      if ((json['@type'] == 'Recipe') ||
          (json['@type'] is List &&
              (json['@type'] as List).contains('Recipe'))) {
        return json;
      }
      if (json.containsKey('@graph') && json['@graph'] is List) {
        for (final node in json['@graph']) {
          final found = _findRecipeNode(node);
          if (found != null) return found;
        }
      }
    }
    if (json is List) {
      for (final entry in json) {
        final found = _findRecipeNode(entry);
        if (found != null) return found;
      }
    }
    return null;
  }

  String? _fallbackTitle(dom.Document doc) {
    return doc.querySelector('title')?.text.trim();
  }

  List<String> _fallbackIngredients(dom.Document doc) {
    final items = <String>[];
    for (final li in doc.querySelectorAll('li')) {
      final text = _cleanText(li.text);
      if (_looksLikeIngredient(text)) {
        items.add(text);
      }
      if (items.length >= 10) break;
    }
    return items;
  }

  List<String> _fallbackSteps(dom.Document doc) {
    final steps = <String>[];
    for (final p in doc.querySelectorAll('p')) {
      final text = _cleanText(p.text);
      if (text.split(' ').length > 5) steps.add(text);
      if (steps.length >= 10) break;
    }
    return steps;
  }

  String _requireUser(String userKey) {
    if (userKey.isEmpty) {
      throw sp.AccessDeniedException(message: 'Missing user identity');
    }
    return userKey;
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _looksLikeIngredient(String text) {
    final lower = text.toLowerCase();
    return RegExp(r'\d').hasMatch(text) ||
        lower.contains('cup') ||
        lower.contains('tsp') ||
        lower.contains('tbsp') ||
        lower.contains('g') ||
        lower.contains('ml');
  }
}

class _JsonLdRecipe {
  const _JsonLdRecipe({
    this.title,
    this.ingredients = const [],
    this.steps = const [],
  });
  final String? title;
  final List<String> ingredients;
  final List<String> steps;
}

const _userAgents = [
  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1',
  'Mozilla/5.0 (Linux; Android 14; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_5_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
];
