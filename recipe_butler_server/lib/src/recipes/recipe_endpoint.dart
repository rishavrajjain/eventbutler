import 'package:serverpod/serverpod.dart';
import 'package:serverpod/protocol.dart' as sp;

import '../generated/protocol.dart';

class RecipeEndpoint extends Endpoint {
  /// Create a recipe owned by the authenticated user.
  Future<Recipe> createRecipe(
    Session session,
    String userKey,
    String title, {
    String? sourceUrl,
  }) async {
    final userId = _requireUser(userKey);

    final recipe = Recipe(
      title: title,
      ownerUserId: userId,
      sourceUrl: sourceUrl,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await Recipe.db.insertRow(session, recipe);
    return inserted;
  }

  /// List recipes for the authenticated user.
  Future<List<Recipe>> listMyRecipes(Session session, String userKey) async {
    final userId = _requireUser(userKey);

    return Recipe.db.find(
      session,
      where: (r) => r.ownerUserId.equals(userId),
      orderBy: (r) => r.createdAt,
      orderDescending: true,
    );
  }

  /// Get a single recipe; ensures ownership.
  Future<Recipe?> getRecipe(
    Session session,
    String userKey,
    int recipeId,
  ) async {
    final userId = _requireUser(userKey);

    final recipe = await Recipe.db.findById(session, recipeId);
    if (recipe == null || recipe.ownerUserId != userId) return null;
    return recipe;
  }

  /// Delete a recipe; returns true if deleted.
  Future<bool> deleteRecipe(
    Session session,
    String userKey,
    int recipeId,
  ) async {
    final userId = _requireUser(userKey);

    final recipe = await Recipe.db.findById(session, recipeId);
    if (recipe == null || recipe.ownerUserId != userId) return false;

    await Recipe.db.deleteRow(session, recipe);
    // Cascade delete ingredients and steps.
    await Ingredient.db.deleteWhere(
      session,
      where: (i) => i.recipeId.equals(recipeId),
    );
    await RecipeStep.db.deleteWhere(
      session,
      where: (s) => s.recipeId.equals(recipeId),
    );
    return true;
  }

  String _requireUser(String userKey) {
    if (userKey.isEmpty) {
      throw sp.AccessDeniedException(message: 'Missing user identity');
    }
    return userKey;
  }
}
