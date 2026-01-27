// ignore_for_file: unused_field

import 'package:recipe_butler_client/recipe_butler_client.dart';

import 'serverpod_client_service.dart';

class ReminderService {
  ReminderService({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;

  Client get _client => _clientService.client;

  Future<List<Reminder>> listMyReminders(
    String userKey, {
    DateTime? after,
  }) async {
    return _client.reminders.listMyReminders(userKey, after: after);
  }

  Future<List<Reminder>> listRemindersForList(
    String userKey,
    int listId,
  ) async {
    return _client.reminders.listRemindersForList(userKey, listId);
  }

  Future<Reminder> addReminder(
    String userKey,
    int listId,
    String title,
    DateTime dueAt, {
    String? targetEmail,
  }) async {
    return _client.reminders.addReminder(
      userKey,
      listId,
      title,
      dueAt,
      targetEmail,
    );
  }

  Future<Reminder?> toggleReminder(
    String userKey,
    int reminderId,
    bool isDone,
  ) async {
    return _client.reminders.toggleReminder(userKey, reminderId, isDone);
  }

  Future<void> deleteReminder(String userKey, int reminderId) async {
    await _client.reminders.deleteReminder(userKey, reminderId);
  }
}
