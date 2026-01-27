import 'package:recipe_butler_client/recipe_butler_client.dart';

import 'serverpod_client_service.dart';

class ShoppingListService {
  ShoppingListService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Client get _client => _clientService.client;

  Future<List<ShoppingList>> listShoppingLists(String userKey) async {
    return _client.shopping.listMyShoppingLists(userKey);
  }

  Future<ShoppingList> createShoppingList(String userKey, String name) async {
    return _client.shopping.createShoppingList(userKey, name);
  }

  Future<List<ShoppingItem>> listItems(String userKey, int listId) async {
    return _client.shopping.listShoppingItems(userKey, listId);
  }

  Future<ShoppingItem> addItem(
    String userKey,
    int listId,
    String text, {
    String? category,
  }) async {
    return _client.shopping.addShoppingItem(userKey, listId, text, category);
  }

  Future<ShoppingItem?> toggleItem(
    String userKey,
    int itemId,
    bool isChecked,
  ) async {
    return _client.shopping.toggleShoppingItem(userKey, itemId, isChecked);
  }

  Future<ShoppingItem?> updateCategory(
    String userKey,
    int itemId,
    String category,
  ) async {
    return _client.shopping.updateShoppingItemCategory(
      userKey,
      itemId,
      category,
    );
  }

  Future<void> saveCategoryPreset(String userKey, String name) async {
    // Placeholder: categories are client-side only for now.
  }

  Stream<ShoppingListEvent> subscribeToList(String userKey, int listId) {
    return _client.shopping.subscribeShoppingList(userKey, listId);
  }

  Future<Invite> createInvite(String userKey, int listId, String role) async {
    return _client.shopping.createInvite(userKey, listId, role);
  }

  Future<int?> acceptInvite(String userKey, String token) async {
    return _client.shopping.acceptInvite(userKey, token);
  }
}
