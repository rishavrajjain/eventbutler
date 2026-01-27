import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../../providers/shopping_lists_provider.dart';
import '../../../providers/tasks_provider.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../tasks/task_chat_screen.dart';

const _surfaceLight = Color(0xFFF7F8FC); // Matches app theme
const _accent = Color(0xFFF6C90E);
const _inkBlack = Color(0xFF111217);
const _textMuted = Color(0xFF6B7280);

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await context.read<ShoppingListsProvider>().ensureActiveList();
    if (mounted) setState(() => _bootstrapped = true);
  }

  Future<void> _refreshAll() async {
    final listsProvider = context.read<ShoppingListsProvider>();
    final tasksProvider = context.read<TasksProvider>();
    await listsProvider.ensureActiveList();
    for (final list in listsProvider.lists) {
      if (list.id != null) {
        await tasksProvider.loadTasks(list.id!, force: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listsProvider = context.watch<ShoppingListsProvider>();
    final lists = listsProvider.lists;

    if (!_bootstrapped || (listsProvider.isLoading && lists.isEmpty)) {
      return const Scaffold(
        backgroundColor: _surfaceLight,
        body: SafeArea(child: LoadingWidget(message: 'Loading tasks...')),
      );
    }

    if (listsProvider.error != null && lists.isEmpty) {
      return Scaffold(
        backgroundColor: _surfaceLight,
        body: SafeArea(
          child: ErrorStateWidget(
            message: listsProvider.error!,
            onRetry: listsProvider.ensureActiveList,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _surfaceLight,
      body: SafeArea(
        child: RefreshIndicator(
          color: _accent,
          onRefresh: _refreshAll,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              _HeroHeader(listCount: lists.length),
              const SizedBox(height: 24),
              ...lists.map(
                (list) => _TaskChatPreview(key: ValueKey(list.id), list: list),
              ),
              if (lists.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: EmptyStateWidget(
                    title: 'No shopping lists yet',
                    subtitle: 'Create one from Shopping to start adding tasks.',
                    icon: Icons.chat_bubble_outline_rounded,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskChatPreview extends StatefulWidget {
  const _TaskChatPreview({super.key, required this.list});

  final ShoppingList list;

  @override
  State<_TaskChatPreview> createState() => _TaskChatPreviewState();
}

class _TaskChatPreviewState extends State<_TaskChatPreview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant _TaskChatPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list.id != widget.list.id) {
      _load(force: true);
    }
  }

  Future<void> _load({bool force = false}) async {
    final listId = widget.list.id;
    if (listId == null) return;
    await context.read<TasksProvider>().loadTasks(listId, force: force);
  }

  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TasksProvider>();
    final listId = widget.list.id!;
    final messages = tasksProvider.tasksForList(listId);
    final isLoading = tasksProvider.isLoading(listId);

    final last = messages.isNotEmpty ? messages.last : null;
    final lastText = last?.text ?? 'No messages yet';
    final lastTime = last?.createdAt.toLocal();
    final timeLabel = lastTime == null
        ? ''
        : TimeOfDay.fromDateTime(lastTime).format(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isLoading
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskChatScreen(list: widget.list),
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_note_outlined,
                    color: _inkBlack,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.list.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: _inkBlack,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isLoading && timeLabel.isNotEmpty)
                            Text(
                              timeLabel,
                              style: const TextStyle(
                                color: _textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (isLoading)
                        const Text(
                          'Loading…',
                          style: TextStyle(color: _textMuted),
                        )
                      else
                        Text(
                          lastText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textMuted,
                            height: 1.3,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.listCount});

  final int listCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_inkBlack, Color(0xFF2C3E50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Tasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  listCount == 1 ? '1 Active' : '$listCount Active',
                  style: const TextStyle(
                    color: _accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Coordinate tasks and chat with your group for each event.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
