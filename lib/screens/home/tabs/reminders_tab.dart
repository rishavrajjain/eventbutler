import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../../providers/reminders_provider.dart';
import '../../../providers/shopping_lists_provider.dart';

import '../../../widgets/error_state_widget.dart';
import '../../../widgets/loading_widget.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final lists = context.read<ShoppingListsProvider>();
    final reminders = context.read<RemindersProvider>();
    await lists.ensureActiveList();
    await reminders.loadMyReminders(force: true);
    if (!mounted) return;
    setState(() => _bootstrapped = true);
  }

  @override
  Widget build(BuildContext context) {
    final remindersProvider = context.watch<RemindersProvider>();
    final listsProvider = context.watch<ShoppingListsProvider>();
    final reminders = remindersProvider.reminders;

    if (!_bootstrapped ||
        (remindersProvider.isLoading && reminders.isEmpty) ||
        (listsProvider.isLoading && listsProvider.lists.isEmpty)) {
      return const Scaffold(
        body: SafeArea(child: LoadingWidget(message: 'Loading reminders...')),
      );
    }

    if ((remindersProvider.error != null && reminders.isEmpty) ||
        (listsProvider.error != null && listsProvider.lists.isEmpty)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reminders')),
        body: SafeArea(
          child: ErrorStateWidget(
            message: remindersProvider.error ?? listsProvider.error!,
            onRetry: _init,
          ),
        ),
      );
    }

    final upcoming = reminders.where((r) => !r.isDone).toList()
      ..sort(_dueThenId);
    final completed = reminders.where((r) => r.isDone).toList()
      ..sort(_dueThenId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            tooltip: 'Add reminder',
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => _openNewReminderSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _init();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              if (upcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Image(
                          image: AssetImage(
                            'images/butler_logo_reminder_empty.png',
                          ),
                          height: 200,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No upcoming reminders',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111217),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to schedule a reminder for your events.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                _SectionHeader(label: 'Upcoming', count: upcoming.length),
                const SizedBox(height: 8),
                ...upcoming.map(
                  (reminder) => _ReminderCard(
                    reminder: reminder,
                    listName: _listNameFor(
                      reminder.shoppingListId,
                      listsProvider.lists,
                    ),
                    onToggle: (value) => remindersProvider.toggleReminder(
                      reminder.id!,
                      value ?? false,
                    ),
                    onDelete: () =>
                        remindersProvider.deleteReminder(reminder.id!),
                  ),
                ),
              ],
              if (completed.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionHeader(label: 'Completed', count: completed.length),
                const SizedBox(height: 8),
                ...completed.map(
                  (reminder) => _ReminderCard(
                    reminder: reminder,
                    listName: _listNameFor(
                      reminder.shoppingListId,
                      listsProvider.lists,
                    ),
                    onToggle: (value) => remindersProvider.toggleReminder(
                      reminder.id!,
                      value ?? false,
                    ),
                    onDelete: () =>
                        remindersProvider.deleteReminder(reminder.id!),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  int _dueThenId(Reminder a, Reminder b) {
    final byDue = a.dueAt.compareTo(b.dueAt);
    if (byDue != 0) return byDue;
    return (a.id ?? 0).compareTo(b.id ?? 0);
  }

  String _listNameFor(int listId, List<ShoppingList> lists) {
    for (final list in lists) {
      if (list.id == listId) return list.name;
    }
    return 'List';
  }

  Future<void> _openNewReminderSheet(BuildContext context) async {
    final listsProvider = context.read<ShoppingListsProvider>();
    final remindersProvider = context.read<RemindersProvider>();
    final lists = listsProvider.lists;
    final initialListId =
        listsProvider.activeList?.id ?? (lists.isNotEmpty ? lists.first.id : 0);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: _NewReminderForm(
          lists: lists,
          initialListId: initialListId,
          onSubmit: (listId, title, dueAt, email) async {
            await remindersProvider.addReminder(
              listId: listId,
              title: title,
              dueAt: dueAt,
              targetEmail: email,
            );
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.listName,
    required this.onToggle,
    required this.onDelete,
  });

  final Reminder reminder;
  final String listName;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final due = reminder.dueAt.toLocal();
    final now = DateTime.now();
    final isOverdue = !reminder.isDone && due.isBefore(now);

    String relative() {
      final diff = due.difference(now);
      if (diff.inMinutes.abs() < 1) return 'now';
      if (diff.isNegative) {
        if (diff.inHours.abs() < 1) return '${diff.inMinutes.abs()}m ago';
        if (diff.inHours.abs() < 24) return '${diff.inHours.abs()}h ago';
        return '${diff.inDays.abs()}d ago';
      } else {
        if (diff.inHours < 1) return 'in ${diff.inMinutes}m';
        if (diff.inHours < 24) return 'in ${diff.inHours}h';
        return 'in ${diff.inDays}d';
      }
    }

    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isOverdue ? Colors.red.shade200 : Colors.grey.shade200,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(value: reminder.isDone, onChanged: onToggle),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: reminder.isDone
                          ? Colors.grey.shade500
                          : Colors.black87,
                      decoration: reminder.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isOverdue ? Colors.red : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${TimeOfDay.fromDateTime(due).format(context)} • ${_dateLabel(due)} • $listName',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    relative(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${date.month}/${date.day}';
  }
}

class _NewReminderForm extends StatefulWidget {
  const _NewReminderForm({
    required this.lists,
    required this.initialListId,
    required this.onSubmit,
  });

  final List<ShoppingList> lists;
  final int? initialListId;
  final Future<void> Function(
    int listId,
    String title,
    DateTime dueAt,
    String? email,
  )
  onSubmit;

  @override
  State<_NewReminderForm> createState() => _NewReminderFormState();
}

class _NewReminderFormState extends State<_NewReminderForm> {
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late int? _selectedListId;
  late DateTime _dueAt;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _emailController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.email ?? '',
    );
    _selectedListId = widget.initialListId;
    _dueAt = DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'New reminder',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _selectedListId,
          decoration: const InputDecoration(labelText: 'Shopping list'),
          items: widget.lists
              .where((l) => l.id != null)
              .map(
                (l) => DropdownMenuItem<int>(value: l.id, child: Text(l.name)),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedListId = value),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'e.g. Buy cake at 6pm',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Send email to (optional)',
            hintText: 'you@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Due date'),
                child: Text(
                  '${_dueAt.month}/${_dueAt.day}/${_dueAt.year}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Time'),
                child: Text(
                  TimeOfDay.fromDateTime(_dueAt).format(context),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Pick date & time',
              onPressed: _pickDateTime,
              icon: const Icon(Icons.schedule),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF111217),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    if (title.isEmpty || _selectedListId == null) return;
    setState(() => _saving = true);
    await widget.onSubmit(_selectedListId!, title, _dueAt, email);
  }
}
