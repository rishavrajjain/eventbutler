import 'package:flutter/foundation.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../services/reminder_service.dart';

class RemindersProvider extends ChangeNotifier {
  RemindersProvider({ReminderService? reminderService})
    : _reminderService = reminderService ?? ReminderService();

  final ReminderService _reminderService;

  String _userKey = '';
  bool _loading = false;
  bool _mutating = false;
  List<Reminder> _reminders = [];
  String? _error;

  bool get isLoading => _loading;
  bool get isMutating => _mutating;
  List<Reminder> get reminders => _reminders;
  String? get error => _error;

  void setUser(String userKey) {
    _userKey = userKey;
    _reminders = [];
    _error = null;
    _loading = false;
    _mutating = false;
    notifyListeners();
  }

  Future<void> loadMyReminders({bool force = false}) async {
    if (_userKey.isEmpty) return;
    if (!force && _reminders.isNotEmpty) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _reminders = await _reminderService.listMyReminders(_userKey);
      _sort();
    } catch (e) {
      _error = 'Could not load reminders';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshForList(int listId) async {
    if (_userKey.isEmpty) return;
    _mutating = true;
    notifyListeners();
    try {
      final listReminders = await _reminderService.listRemindersForList(
        _userKey,
        listId,
      );
      _mergeList(listReminders, listId);
    } catch (e) {
      _error = 'Could not refresh reminders';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> addReminder({
    required int listId,
    required String title,
    required DateTime dueAt,
    String? targetEmail,
  }) async {
    if (_userKey.isEmpty) return;
    _mutating = true;
    notifyListeners();
    try {
      final created = await _reminderService.addReminder(
        _userKey,
        listId,
        title,
        dueAt,
        targetEmail: targetEmail,
      );
      _reminders = [..._reminders, created];
      _sort();
    } catch (e) {
      _error = 'Could not add reminder';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> toggleReminder(int reminderId, bool isDone) async {
    if (_userKey.isEmpty) return;
    _mutating = true;
    notifyListeners();
    try {
      final updated = await _reminderService.toggleReminder(
        _userKey,
        reminderId,
        isDone,
      );
      if (updated != null) {
        _reminders = _reminders
            .map((r) => r.id == reminderId ? updated : r)
            .toList(growable: false);
        _sort();
      }
    } catch (e) {
      _error = 'Could not update reminder';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> deleteReminder(int reminderId) async {
    if (_userKey.isEmpty) return;
    _mutating = true;
    notifyListeners();
    try {
      await _reminderService.deleteReminder(_userKey, reminderId);
      _reminders = _reminders.where((r) => r.id != reminderId).toList();
    } catch (e) {
      _error = 'Could not delete reminder';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  List<Reminder> remindersForList(int listId) =>
      _reminders.where((r) => r.shoppingListId == listId).toList()
        ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

  void _sort() {
    _reminders.sort((a, b) {
      final doneA = a.isDone ? 1 : 0;
      final doneB = b.isDone ? 1 : 0;
      if (doneA != doneB) return doneA.compareTo(doneB);
      return a.dueAt.compareTo(b.dueAt);
    });
  }

  void _mergeList(List<Reminder> incoming, int listId) {
    final retained = _reminders.where((r) => r.shoppingListId != listId);
    _reminders = [...retained, ...incoming];
    _sort();
  }
}
