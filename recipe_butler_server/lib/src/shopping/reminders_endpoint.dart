import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class RemindersEndpoint extends Endpoint {
  Future<List<Reminder>> listMyReminders(
    Session session,
    String userKey, {
    DateTime? after,
  }) async {
    final userId = _requireUser(userKey);
    final memberships = await ShoppingListMember.db.find(
      session,
      where: (m) => m.userId.equals(userId),
    );
    final listIds = memberships.map((m) => m.shoppingListId).toSet();
    if (listIds.isEmpty) return [];

    final reminders = await Reminder.db.find(
      session,
      where: (r) => r.shoppingListId.inSet(listIds),
      orderBy: (r) => r.dueAt,
    );

    if (after == null) return reminders;
    return reminders
        .where(
          (r) => r.dueAt.isAfter(after) || r.dueAt.isAtSameMomentAs(after),
        )
        .toList();
  }

  Future<List<Reminder>> listRemindersForList(
    Session session,
    String userKey,
    int listId,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanView(session, userId, listId);
    return Reminder.db.find(
      session,
      where: (r) => r.shoppingListId.equals(listId),
      orderBy: (r) => r.dueAt,
    );
  }

  Future<Reminder> addReminder(
    Session session,
    String userKey,
    int listId,
    String title,
    DateTime dueAt,
    String? targetEmail,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanEdit(session, userId, listId);

    final reminder = Reminder(
      shoppingListId: listId,
      createdByUserId: userId,
      title: title,
      dueAt: dueAt.toUtc(),
      isDone: false,
      createdAt: DateTime.now().toUtc(),
      targetEmail: targetEmail?.trim(),
    );

    final created = await Reminder.db.insertRow(session, reminder);

    if (created.targetEmail != null && created.targetEmail!.isNotEmpty) {
      try {
        // ignore: deprecated_member_use
        await session.serverpod.futureCallAtTime(
          'sendReminderEmail',
          created,
          created.dueAt,
        );
      } catch (e, st) {
        session.log(
          'Failed to schedule reminder email: $e',
          level: LogLevel.warning,
          stackTrace: st,
        );
      }
    }

    return created;
  }

  Future<Reminder?> toggleReminder(
    Session session,
    String userKey,
    int reminderId,
    bool isDone,
  ) async {
    final userId = _requireUser(userKey);
    final reminder = await _requireReminder(session, reminderId);
    await _assertCanEdit(session, userId, reminder.shoppingListId);

    final updated = reminder.copyWith(isDone: isDone);
    await Reminder.db.updateRow(session, updated);
    return updated;
  }

  Future<void> deleteReminder(
    Session session,
    String userKey,
    int reminderId,
  ) async {
    final userId = _requireUser(userKey);
    final reminder = await _requireReminder(session, reminderId);
    await _assertCanEdit(session, userId, reminder.shoppingListId);
    await Reminder.db.deleteRow(session, reminder);
  }

  // ---- helpers ----

  String _requireUser(String userKey) {
    if (userKey.isEmpty) {
      throw sp.AccessDeniedException(message: 'Missing user identity');
    }
    return userKey;
  }

  Future<Reminder> _requireReminder(Session session, int id) async {
    final reminder = await Reminder.db.findById(session, id);
    if (reminder == null) {
      throw sp.AccessDeniedException(message: 'Reminder not found');
    }
    return reminder;
  }

  Future<void> _assertCanView(
    Session session,
    String userId,
    int listId,
  ) async {
    final list = await ShoppingList.db.findById(session, listId);
    if (list == null) {
      throw sp.AccessDeniedException(message: 'List not found');
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
}
