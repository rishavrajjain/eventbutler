import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TasksEndpoint extends Endpoint {
  String _channelName(int listId) => 'shopping_list_$listId';

  Future<List<TaskMessage>> listTasks(
    Session session,
    String userKey,
    int listId,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanView(session, userId, listId);
    return TaskMessage.db.find(
      session,
      where: (t) => t.shoppingListId.equals(listId),
      orderBy: (t) => t.createdAt,
    );
  }

  Future<TaskMessage> addTask(
    Session session,
    String userKey,
    int listId,
    String text,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanEdit(session, userId, listId);

    final message = TaskMessage(
      shoppingListId: listId,
      userId: userId,
      text: text,
      createdAt: DateTime.now().toUtc(),
    );
    final created = await TaskMessage.db.insertRow(session, message);

    await _postEvent(
      session,
      listId,
      ShoppingListEvent(
        listId: listId,
        type: 'taskAdded',
        task: created,
        taskId: created.id,
        text: created.text,
        updatedByUserId: userId,
        sentAt: DateTime.now().toUtc(),
      ),
    );

    return created;
  }

  // ---- helpers ----

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

  Future<void> _assertCanEdit(
    Session session,
    String userId,
    int listId,
  ) async {
    final list = await ShoppingList.db.findById(session, listId);
    if (list == null) throw sp.AccessDeniedException(message: 'Not found');
    if (list.ownerUserId == userId) return;
    final member = await ShoppingListMember.db.findFirstRow(
      session,
      where: (m) => m.shoppingListId.equals(listId) & m.userId.equals(userId),
    );
    if (member == null || (member.role != 'owner' && member.role != 'editor')) {
      throw sp.AccessDeniedException(message: 'Edit not allowed');
    }
  }

  Future<void> _postEvent(
    Session session,
    int listId,
    ShoppingListEvent event,
  ) async {
    try {
      final useGlobal = session.serverpod.redisController != null;
      await session.messages.postMessage(
        _channelName(listId),
        event,
        global: useGlobal,
      );
    } catch (e, st) {
      session.log(
        'Realtime broadcast skipped (likely Redis disabled): $e',
        level: LogLevel.warning,
        stackTrace: st,
      );
    }
  }
}
