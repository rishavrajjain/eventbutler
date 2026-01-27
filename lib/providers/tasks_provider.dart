import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../services/task_service.dart';

class TasksProvider extends ChangeNotifier {
  TasksProvider({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  final TaskService _taskService;

  String _userKey = '';
  final Map<int, List<TaskMessage>> _tasksByList = {};
  final Map<int, bool> _loadingByList = {};
  final Map<int, bool> _sendingByList = {};
  final Map<int, StreamSubscription<ShoppingListEvent>> _subscriptions = {};
  final Map<int, Timer> _pollers = {};
  final Set<int> _pollingLists = {};
  String? _error;

  String? get error => _error;

  List<TaskMessage> tasksForList(int listId) =>
      _tasksByList[listId] ?? const [];

  bool isLoading(int listId) => _loadingByList[listId] ?? false;

  bool isSending(int listId) => _sendingByList[listId] ?? false;

  void setUser(String userKey) {
    _userKey = userKey;
    _tasksByList.clear();
    _loadingByList.clear();
    _sendingByList.clear();
    _clearSubscriptions();
    _clearPollers();
    _error = null;
  }

  Future<void> loadTasks(int listId, {bool force = false}) async {
    if (_userKey.isEmpty) return;
    if (_loadingByList[listId] == true) return;
    if (!force && _tasksByList[listId] != null) return;

    _loadingByList[listId] = true;
    notifyListeners();

    try {
      final tasks = await _taskService.listTasks(_userKey, listId);
      _tasksByList[listId] = tasks;
      await _ensureSubscription(listId);
    } catch (e) {
      _error = 'Could not load tasks';
    } finally {
      _loadingByList[listId] = false;
      notifyListeners();
    }
  }

  Future<void> addTask(int listId, String text) async {
    if (_userKey.isEmpty || text.trim().isEmpty) return;
    _sendingByList[listId] = true;
    notifyListeners();
    try {
      final created = await _taskService.addTask(_userKey, listId, text.trim());
      _upsertTask(listId, created);
    } catch (e) {
      _error = 'Could not add task';
    } finally {
      _sendingByList[listId] = false;
      notifyListeners();
    }
  }

  Future<void> _ensureSubscription(int listId) async {
    if (_userKey.isEmpty) return;
    if (_subscriptions.containsKey(listId)) return;

    try {
      final stream = _taskService.subscribeToList(_userKey, listId);
      final sub = stream.listen(
        (event) => _handleEvent(listId, event),
        onError: (e, __) => _handleStreamError(listId, e),
        onDone: () => _handleStreamDone(listId),
      );
      _subscriptions[listId] = sub;
      _stopPoller(listId); // prefer realtime when connected
    } catch (e) {
      debugPrint('[Tasks] could not subscribe to list $listId: $e');
      _startPoller(listId); // fallback to polling if stream fails to start
    }
  }

  void _handleStreamError(int listId, Object error) {
    debugPrint('[Tasks] stream error for list $listId: $error');
    _subscriptions.remove(listId);
    _startPoller(listId);
    _scheduleResubscribe(listId);
  }

  void _handleStreamDone(int listId) {
    debugPrint('[Tasks] stream closed for list $listId, retrying…');
    _subscriptions.remove(listId);
    _startPoller(listId);
    _scheduleResubscribe(listId);
  }

  void _scheduleResubscribe(int listId, {int attempt = 1}) {
    if (_userKey.isEmpty) return;
    if (attempt > 5) return; // cap retries
    Future.delayed(Duration(milliseconds: 300 * attempt), () async {
      if (_userKey.isEmpty) return;
      if (_subscriptions.containsKey(listId)) return;
      try {
        await _ensureSubscription(listId);
      } catch (e) {
        debugPrint('[Tasks] resubscribe failed ($attempt): $e');
        _scheduleResubscribe(listId, attempt: attempt + 1);
      }
    });
  }

  void _handleEvent(int listId, ShoppingListEvent event) {
    if (event.task != null) {
      _upsertTask(listId, event.task!);
    }
    // We got realtime data; stop fallback polling.
    _stopPoller(listId);
  }

  void _upsertTask(int listId, TaskMessage task) {
    final List<TaskMessage> current = [
      ...(_tasksByList[listId] ?? <TaskMessage>[])
    ];
    final index = current.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      current[index] = task;
    } else {
      current.add(task);
    }
    current.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _tasksByList[listId] = current;
    notifyListeners();
  }

  void _clearSubscriptions() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  void _startPoller(int listId) {
    _stopPoller(listId);
    if (_userKey.isEmpty) return;
    // Poll every 5s as a safety net when streams are unavailable.
    _pollers[listId] = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _pollList(listId),
    );
  }

  Future<void> _pollList(int listId) async {
    if (_pollingLists.contains(listId)) return;
    _pollingLists.add(listId);
    try {
      final latest = await _taskService.listTasks(_userKey, listId);
      _tasksByList[listId] = latest;
      notifyListeners();
    } catch (e) {
      debugPrint('[Tasks] poll failed for list $listId: $e');
    } finally {
      _pollingLists.remove(listId);
    }
  }

  void _stopPoller(int listId) {
    _pollers[listId]?.cancel();
    _pollers.remove(listId);
  }

  void _clearPollers() {
    for (final poll in _pollers.values) {
      poll.cancel();
    }
    _pollers.clear();
    _pollingLists.clear();
  }

  @override
  void dispose() {
    _clearSubscriptions();
    super.dispose();
  }
}
