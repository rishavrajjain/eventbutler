import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../providers/auth_provider.dart';
import '../../providers/shopping_lists_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../widgets/loading_widget.dart';

const _night = Color(0xFF0F172A);
const _accent = Color(0xFFF6C90E);
const _textMuted = Color(0xFF6B7280);
const _cardStroke = Color(0xFFE5E7EE);

class TaskChatScreen extends StatefulWidget {
  const TaskChatScreen({super.key, required this.list});

  final ShoppingList list;

  @override
  State<TaskChatScreen> createState() => _TaskChatScreenState();
}

class _TaskChatScreenState extends State<TaskChatScreen> {
  final _controller = TextEditingController();
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await context.read<TasksProvider>().loadTasks(widget.list.id!, force: true);
    if (mounted) setState(() => _bootstrapped = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
        backgroundColor: Colors.white,
        foregroundColor: _night,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Add to shopping list',
            icon: const Icon(Icons.playlist_add),
            onPressed: () => _showAddItemSheet(context),
          ),
          IconButton(
            tooltip: 'Share list',
            icon: const Icon(Icons.ios_share),
            onPressed: () => _shareList(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer2<TasksProvider, AuthProvider>(
          builder: (context, tasks, auth, _) {
            final listId = widget.list.id!;
            final messages = tasks.tasksForList(listId);
            final isLoading = tasks.isLoading(listId);

            if (!_bootstrapped || isLoading) {
              return const LoadingWidget(message: 'Loading chat...');
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    itemCount: messages.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.userId == auth.userId;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _TaskBubble(message: message, isMine: isMine),
                      );
                    },
                  ),
                ),
                _Composer(
                  controller: _controller,
                  isSending: tasks.isSending(listId),
                  onSend: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    await tasks.addTask(listId, text);
                    _controller.clear();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddItemSheet(BuildContext context) async {
    final listId = widget.list.id;
    if (listId == null) return;
    final modalContext = context;
    final lists = context.read<ShoppingListsProvider>();
    await lists.setActiveList(listId);
    if (!mounted) return;
    if (!context.mounted) return;

    final itemController = TextEditingController();
    bool saving = false;

    await showModalBottomSheet(
      context: modalContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add to ${widget.list.name}',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: itemController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitItem(
                      ctx,
                      lists,
                      itemController,
                      savingSetter: (v) => setState(() => saving = v),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                      hintText: 'e.g. Birthday cake',
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: saving
                        ? null
                        : () => _submitItem(
                            ctx,
                            lists,
                            itemController,
                            savingSetter: (v) => setState(() => saving = v),
                          ),
                    icon: saving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add),
                    label: Text(saving ? 'Adding...' : 'Add to list'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _night,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _submitItem(
    BuildContext ctx,
    ShoppingListsProvider lists,
    TextEditingController controller, {
    required void Function(bool) savingSetter,
  }) async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    savingSetter(true);
    await lists.addItem(text);
    savingSetter(false);
    if (!ctx.mounted) return;
    controller.clear();
    Navigator.of(ctx).pop();
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text('Item added to shopping list')),
    );
  }

  Future<void> _shareList(BuildContext context) async {
    final provider = context.read<ShoppingListsProvider>();
    // Ensure the active list matches this chat so the share call targets it.
    await provider.setActiveList(widget.list.id!);
    final token = await provider.createShareToken(role: 'editor');
    if (!context.mounted || token == null) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share this token',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Anyone with this code can join your list as an editor.',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      token,
                      style: const TextStyle(
                        letterSpacing: 2,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: token));
                        Navigator.of(ctx).maybePop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token copied')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskBubble extends StatelessWidget {
  const _TaskBubble({required this.message, required this.isMine});

  final TaskMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(
      message.createdAt.toLocal(),
    ).format(context);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isMine ? _night : _accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMine ? Colors.black : _cardStroke,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isMine ? Colors.white : _night,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: isMine ? Colors.white70 : _textMuted,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  final TextEditingController controller;
  final Future<void> Function() onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _cardStroke)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Send a task or note…',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: isSending ? null : onSend,
            icon: isSending
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(isSending ? 'Sending' : 'Send'),
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _night,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
