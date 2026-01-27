import 'package:recipe_butler_client/recipe_butler_client.dart';

import 'serverpod_client_service.dart';

class TaskService {
  TaskService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Client get _client => _clientService.client;

  Future<List<TaskMessage>> listTasks(String userKey, int listId) async {
    return _client.tasks.listTasks(userKey, listId);
  }

  Future<TaskMessage> addTask(String userKey, int listId, String text) async {
    return _client.tasks.addTask(userKey, listId, text);
  }

  Stream<ShoppingListEvent> subscribeToList(String userKey, int listId) {
    return _client.shopping.subscribeShoppingList(userKey, listId);
  }
}
