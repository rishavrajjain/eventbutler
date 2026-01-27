import 'package:recipe_butler_client/recipe_butler_client.dart';

import 'serverpod_client_service.dart';

class RecipeService {
  RecipeService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Client get _client => _clientService.client;

  Future<List<Recipe>> listMyRecipes(String userKey) async {
    return _client.recipe.listMyRecipes(userKey);
  }

  Future<Recipe> createRecipe({
    required String userKey,
    required String title,
    String? sourceUrl,
  }) async {
    return _client.recipe.createRecipe(userKey, title, sourceUrl: sourceUrl);
  }

  Future<Recipe?> getRecipe(String userKey, int id) async {
    return _client.recipe.getRecipe(userKey, id);
  }

  Future<bool> deleteRecipe(String userKey, int id) async {
    return _client.recipe.deleteRecipe(userKey, id);
  }

  Future<Recipe> importFromUrl(String userKey, String url) async {
    return _client.import.importRecipeFromUrl(userKey, url);
  }
}
