import 'package:flutter/foundation.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../services/recipe_service.dart';

class RecipesProvider extends ChangeNotifier {
  RecipesProvider({RecipeService? recipeService})
    : _recipeService = recipeService ?? RecipeService();

  final RecipeService _recipeService;
  String _userKey = '';

  bool _loading = false;
  List<Recipe> _recipes = [];
  String? _error;
  bool _actionInFlight = false;

  bool get isLoading => _loading;
  List<Recipe> get recipes => _recipes;
  String? get error => _error;
  bool get isMutating => _actionInFlight;
  String get userKey => _userKey;

  void setUser(String userKey) {
    _userKey = userKey;
  }

  Future<void> loadRecipes() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      if (_userKey.isEmpty) throw Exception('No user set');
      _recipes = await _recipeService.listMyRecipes(_userKey);
    } catch (e) {
      _error = 'Could not load recipes';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Recipe?> fetchRecipe(int id) async {
    try {
      if (_userKey.isEmpty) throw Exception('No user set');
      return await _recipeService.getRecipe(_userKey, id);
    } catch (_) {
      return null;
    }
  }

  Future<void> create(String title, {String? sourceUrl}) async {
    _actionInFlight = true;
    notifyListeners();
    try {
      final created = await _recipeService.createRecipe(
        userKey: _userKey,
        title: title,
        sourceUrl: sourceUrl,
      );
      _recipes = [created, ..._recipes];
    } catch (e) {
      _error = 'Could not create recipe';
    } finally {
      _actionInFlight = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    _actionInFlight = true;
    notifyListeners();
    try {
      final success = await _recipeService.deleteRecipe(_userKey, id);
      if (success) {
        _recipes = _recipes.where((r) => r.id != id).toList();
      }
    } catch (e) {
      _error = 'Could not delete recipe';
    } finally {
      _actionInFlight = false;
      notifyListeners();
    }
  }

  Future<void> importFromUrl(String url) async {
    _actionInFlight = true;
    _error = null;
    notifyListeners();
    try {
      if (_userKey.isEmpty) throw Exception('No user set');
      final imported = await _recipeService.importFromUrl(_userKey, url);
      _recipes = [imported, ..._recipes];
    } catch (e) {
      _error = 'Could not import recipe';
    } finally {
      _actionInFlight = false;
      notifyListeners();
    }
  }
}
