import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../providers/auth_provider.dart';
import '../../providers/shopping_lists_provider.dart';
import '../../providers/reminders_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../services/butler_service.dart';
import '../../widgets/loading_widget.dart';

const _night = Color(0xFF0F172A);
const _accent = Color(0xFFF6C90E);
const _textMuted = Color(0xFF6B7280);
const _cardStroke = Color(0xFFE5E7EB);
const _aiGlow = Color(0xFFFDE68A);

class TaskChatScreen extends StatefulWidget {
  const TaskChatScreen({super.key, required this.list});

  final ShoppingList list;

  @override
  State<TaskChatScreen> createState() => _TaskChatScreenState();
}

class _TaskChatScreenState extends State<TaskChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _bootstrapped = false;
  bool _aiMode = false;
  bool _aiWorking = false;
  final _aiPrefix = '[BUTLER_JSON]';
  final _butler = ButlerService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await context.read<TasksProvider>().loadTasks(widget.list.id!, force: true);
    if (mounted) setState(() => _bootstrapped = true);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ButlerPayload? _parseAiPayload(String text) {
    if (!text.startsWith(_aiPrefix)) return null;
    try {
      final jsonStr = text.substring(_aiPrefix.length);
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      return ButlerPayload.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  String _userId(BuildContext context) =>
      context.read<AuthProvider>().userId ?? '';

  Future<void> _runAi(int listId, String userPrompt) async {
    final tasksProvider = context.read<TasksProvider>();
    setState(() => _aiWorking = true);
    _scrollToBottom();
    try {
      final result = await _butler.suggest(
        _userId(context),
        listId,
        userPrompt,
        listName: widget.list.name,
      );
      final payloadJson = result.toJson();
      final encoded = jsonEncode(payloadJson);
      await tasksProvider.addTask(
        listId,
        '$_aiPrefix$encoded',
      );
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Butler AI unavailable: $e')),
      );
    } finally {
      if (mounted) setState(() => _aiWorking = false);
    }
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
                  child: messages.isEmpty && !_aiWorking
                      ? _EmptyChat(aiMode: _aiMode)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          itemCount: messages.length + (_aiWorking ? 1 : 0),
                          reverse: false,
                          itemBuilder: (context, index) {
                            // Show typing indicator as last item
                            if (_aiWorking && index == messages.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: _ButlerTypingIndicator(),
                              );
                            }
                            final message = messages[index];
                            final aiPayload = _parseAiPayload(message.text);
                            final isMine = message.userId == auth.userId;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: aiPayload != null
                                  ? _ButlerCard(
                                      payload: aiPayload,
                                      list: widget.list,
                                    )
                                  : _TaskBubble(
                                      message: message, isMine: isMine),
                            );
                          },
                        ),
                ),
                _Composer(
                  controller: _controller,
                  isSending: tasks.isSending(listId) || _aiWorking,
                  aiEnabled: _aiMode,
                  onToggleAi: () => setState(() => _aiMode = !_aiMode),
                  onSend: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    _controller.clear();
                    await tasks.addTask(listId, text);
                    _scrollToBottom();
                    if (_aiMode) {
                      await _runAi(listId, text);
                    }
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

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------
class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.aiMode});

  final bool aiMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: aiMode ? _aiGlow : const Color(0xFFF3F4F6),
              ),
              child: Icon(
                aiMode ? Icons.auto_fix_high : Icons.chat_bubble_outline,
                size: 30,
                color: aiMode ? _night : _textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              aiMode
                  ? 'Ask Butler AI anything'
                  : 'Start the conversation',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _night,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              aiMode
                  ? '"What do I need for a birthday party?"\n"Suggest a timeline for my event"'
                  : 'Coordinate tasks with your team.\nTap the wand to ask Butler AI.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chat bubbles
// ---------------------------------------------------------------------------
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
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Butler AI typing indicator
// ---------------------------------------------------------------------------
class _ButlerTypingIndicator extends StatefulWidget {
  const _ButlerTypingIndicator();

  @override
  State<_ButlerTypingIndicator> createState() => _ButlerTypingIndicatorState();
}

class _ButlerTypingIndicatorState extends State<_ButlerTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF7D6), Color(0xFFFEF3C7)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accent.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _accent,
              ),
              child: const Icon(Icons.auto_fix_high, size: 16, color: _night),
            ),
            const SizedBox(width: 10),
            const Text(
              'Butler is thinking',
              style: TextStyle(
                color: _night,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedBuilder(
              animation: _anim,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final delay = i * 0.2;
                    final t = (_anim.value - delay).clamp(0.0, 1.0);
                    final scale = 0.5 + 0.5 * (1 - (2 * t - 1).abs());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: _night,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Butler AI Card - Premium event manager response
// ---------------------------------------------------------------------------
class _ButlerCard extends StatefulWidget {
  const _ButlerCard({required this.payload, required this.list});

  final ButlerPayload payload;
  final ShoppingList list;

  @override
  State<_ButlerCard> createState() => _ButlerCardState();
}

class _ButlerCardState extends State<_ButlerCard> {
  final Set<String> _addedItems = {};
  final Set<String> _addedReminders = {};
  bool _addingAll = false;

  @override
  Widget build(BuildContext context) {
    final listsProvider = context.read<ShoppingListsProvider>();
    final remindersProvider = context.read<RemindersProvider>();
    final hasShopping = widget.payload.shopping.isNotEmpty;
    final hasReminders = widget.payload.reminders.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accent.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDE68A), Color(0xFFFCD34D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _night.withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    Icons.auto_fix_high,
                    color: _night,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Butler AI',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: _night,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _night.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _night,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message
          if (widget.payload.message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
              child: Text(
                widget.payload.message,
                style: const TextStyle(
                  color: _night,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  fontSize: 14,
                ),
              ),
            ),
          // Shopping suggestions
          if (hasShopping) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 16, color: _night),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Shopping Suggestions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _night,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (widget.payload.shopping.length > 1)
                    _AddAllButton(
                      label: 'Add all',
                      icon: Icons.add_shopping_cart,
                      loading: _addingAll,
                      allAdded: _addedItems.length ==
                          widget.payload.shopping.length,
                      onPressed: () =>
                          _addAllItems(listsProvider),
                    ),
                ],
              ),
            ),
            ...widget.payload.shopping.map((item) {
              final added = _addedItems.contains(item.title);
              return _SuggestionTile(
                icon: added
                    ? Icons.check_circle
                    : Icons.add_shopping_cart_outlined,
                iconColor: added ? const Color(0xFF16A34A) : _night,
                title: item.title,
                subtitle: [
                  if (item.qty != null && item.qty!.isNotEmpty) 'Qty: ${item.qty}',
                  if (item.notes != null && item.notes!.isNotEmpty) item.notes!,
                ].join(' · '),
                added: added,
                onTap: added
                    ? null
                    : () => _addSingleItem(listsProvider, item),
              );
            }),
          ],
          // Reminder suggestions
          if (hasReminders) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: _night),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Reminder Suggestions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _night,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...widget.payload.reminders.map((rem) {
              final due = _parseDue(rem.dueIso);
              final added = _addedReminders.contains(rem.title);
              return _SuggestionTile(
                icon: added
                    ? Icons.check_circle
                    : Icons.event_available_outlined,
                iconColor: added ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                title: rem.title,
                subtitle: due == null
                    ? 'No time set'
                    : 'Due: ${TimeOfDay.fromDateTime(due.toLocal()).format(context)}',
                added: added,
                onTap: (added || due == null)
                    ? null
                    : () => _addSingleReminder(remindersProvider, rem, due),
              );
            }),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _addSingleItem(
    ShoppingListsProvider listsProvider,
    ButlerShopping item,
  ) async {
    await listsProvider.setActiveList(widget.list.id!);
    await listsProvider.addItem(item.title, category: null);
    if (!mounted) return;
    setState(() => _addedItems.add(item.title));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.title}" added to ${widget.list.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _addAllItems(ShoppingListsProvider listsProvider) async {
    setState(() => _addingAll = true);
    await listsProvider.setActiveList(widget.list.id!);
    for (final item in widget.payload.shopping) {
      if (_addedItems.contains(item.title)) continue;
      await listsProvider.addItem(item.title, category: null);
      if (!mounted) return;
      setState(() => _addedItems.add(item.title));
    }
    if (!mounted) return;
    setState(() => _addingAll = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.payload.shopping.length} items added to ${widget.list.name}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _addSingleReminder(
    RemindersProvider remindersProvider,
    ButlerReminder rem,
    DateTime due,
  ) async {
    await remindersProvider.addReminder(
      listId: widget.list.id!,
      title: rem.title,
      dueAt: due.toUtc(),
    );
    if (!mounted) return;
    setState(() => _addedReminders.add(rem.title));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${rem.title}" reminder saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static DateTime? _parseDue(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Individual suggestion tile used in Butler card
// ---------------------------------------------------------------------------
class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.added,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool added;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Material(
        color: added
            ? const Color(0xFFF0FDF4)
            : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: added
                    ? const Color(0xFF16A34A).withValues(alpha: 0.25)
                    : _cardStroke,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: added ? const Color(0xFF16A34A) : _night,
                          decoration:
                              added ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    key: ValueKey(added),
                    color: iconColor,
                    size: 22,
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

// ---------------------------------------------------------------------------
// Add All mini button
// ---------------------------------------------------------------------------
class _AddAllButton extends StatelessWidget {
  const _AddAllButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.allAdded,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool loading;
  final bool allAdded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (allAdded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 14, color: Color(0xFF16A34A)),
            SizedBox(width: 4),
            Text(
              'All added',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: _night,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.white,
                  ),
                )
              else
                Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Composer
// ---------------------------------------------------------------------------
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.isSending,
    required this.aiEnabled,
    required this.onToggleAi,
  });

  final TextEditingController controller;
  final Future<void> Function() onSend;
  final bool isSending;
  final bool aiEnabled;
  final VoidCallback onToggleAi;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: aiEnabled ? const Color(0xFFFFFBEB) : Colors.white,
        border: Border(
          top: BorderSide(
            color: aiEnabled ? _accent.withValues(alpha: 0.5) : _cardStroke,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (aiEnabled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.auto_fix_high,
                      size: 14, color: _night),
                  const SizedBox(width: 6),
                  const Text(
                    'Butler AI mode',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _night,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onToggleAi,
                    child: const Text(
                      'Turn off',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _textMuted,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              _AiToggle(
                enabled: aiEnabled,
                onTap: isSending ? null : onToggleAi,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: aiEnabled
                          ? _accent
                          : _cardStroke,
                      width: aiEnabled ? 1.5 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: aiEnabled
                          ? 'Ask Butler anything about your event...'
                          : 'Send a task or note...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _SendButton(
                aiMode: aiEnabled,
                isSending: isSending,
                onSend: onSend,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Send button - changes appearance in AI mode
// ---------------------------------------------------------------------------
class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.aiMode,
    required this.isSending,
    required this.onSend,
  });

  final bool aiMode;
  final bool isSending;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSending ? null : onSend,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: aiMode
                ? const LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFFBBF24)],
                  )
                : null,
            color: aiMode ? null : _accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSending)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _night,
                  ),
                )
              else
                Icon(
                  aiMode ? Icons.auto_fix_high : Icons.send_rounded,
                  size: 18,
                  color: _night,
                ),
              const SizedBox(width: 6),
              Text(
                isSending
                    ? (aiMode ? 'Asking...' : 'Sending')
                    : (aiMode ? 'Ask AI' : 'Send'),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: _night,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI toggle wand
// ---------------------------------------------------------------------------
class _AiToggle extends StatelessWidget {
  const _AiToggle({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: enabled ? 'Disable Butler AI' : 'Enable Butler AI',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled
                ? const LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFFBBF24)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: enabled ? null : Colors.white,
            border: Border.all(
              color: enabled ? _accent : _cardStroke,
              width: enabled ? 2 : 1,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.auto_fix_high,
            size: 22,
            color: enabled ? _night : _textMuted,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models for Butler payload
// ---------------------------------------------------------------------------
class ButlerPayload {
  ButlerPayload({
    required this.message,
    required this.shopping,
    required this.reminders,
  });

  final String message;
  final List<ButlerShopping> shopping;
  final List<ButlerReminder> reminders;

  factory ButlerPayload.fromJson(Map<String, dynamic> json) {
    return ButlerPayload(
      message: (json['message'] ?? '').toString(),
      shopping: (json['shopping'] as List<dynamic>? ?? [])
          .map((e) => ButlerShopping.fromJson(e))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>? ?? [])
          .map((e) => ButlerReminder.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'shopping': shopping.map((e) => e.toJson()).toList(),
        'reminders': reminders.map((e) => e.toJson()).toList(),
      };
}

class ButlerShopping {
  ButlerShopping({required this.title, this.qty, this.notes});

  final String title;
  final String? qty;
  final String? notes;

  factory ButlerShopping.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>? ?? {};
    return ButlerShopping(
      title: (map['title'] ?? '').toString(),
      qty: map['qty']?.toString(),
      notes: map['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (qty != null && qty!.isNotEmpty) 'qty': qty,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class ButlerReminder {
  ButlerReminder({required this.title, this.dueIso, this.item});

  final String title;
  final String? dueIso;
  final String? item;

  factory ButlerReminder.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>? ?? {};
    return ButlerReminder(
      title: (map['title'] ?? '').toString(),
      dueIso: map['dueIso']?.toString(),
      item: map['item']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (dueIso != null && dueIso!.isNotEmpty) 'dueIso': dueIso,
        if (item != null && item!.isNotEmpty) 'item': item,
      };
}
