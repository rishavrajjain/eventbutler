import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../providers/shopping_lists_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'shopping_list_modals.dart';

const _brandYellow = Color(0xFFF6C90E);
const _inkBlack = Color(0xFF111217);
const _surfaceLight = Color(0xFFF7F8FC);
const _panelLight = Colors.white;

const _fadedText = Color(0xFF7A7F8A);

class ShoppingListDetailScreen extends StatefulWidget {
  const ShoppingListDetailScreen({super.key, this.list});

  /// Optional: pass a list to force showing that list. If null, uses active list.
  final ShoppingList? list;

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  final _itemController = TextEditingController();
  String _selectedCategory = _CategoryKeys.my;
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final provider = context.read<ShoppingListsProvider>();
    await provider.loadCategories();
    if (widget.list != null && widget.list!.id != null) {
      await provider.setActiveList(widget.list!.id!);
    } else {
      await provider.ensureActiveList();
    }
    if (mounted) setState(() => _bootstrapped = true);
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListsProvider>(
      builder: (context, provider, _) {
        final activeList = provider.activeList;
        final items = provider.activeItems;
        final categories = provider.categories;
        final sections = _buildSections(items, categories);
        // final uncheckedTotal = items.where((i) => !i.isChecked).length; // Unused

        if (!_bootstrapped || (provider.isLoading && activeList == null)) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F6FA),
            body: SafeArea(child: LoadingWidget(message: 'Loading list...')),
          );
        }

        if (provider.error != null && activeList == null) {
          return Scaffold(
            body: SafeArea(
              child: ErrorStateWidget(
                message: provider.error!,
                onRetry: () => provider.ensureActiveList(),
              ),
            ),
          );
        }

        if (activeList == null) {
          return const Scaffold(
            body: SafeArea(
              child: EmptyStateWidget(
                title: 'No list found',
                subtitle: 'Create or accept a shared list to get started.',
                icon: Icons.list_alt_outlined,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _surfaceLight,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: _panelLight,
            leading: IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh, color: _inkBlack),
              onPressed: () =>
                  context.read<ShoppingListsProvider>().refreshActive(),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _ListSwitcher(
                active: activeList,
                lists: provider.lists,
                onSelect: provider.setActiveList,
                onCreate: provider.createList,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Share',
                icon: const Icon(Icons.ios_share, color: _inkBlack),
                onPressed: () => _shareList(context, provider),
              ),
              IconButton(
                tooltip: 'Join',
                icon: const Icon(Icons.group_add_outlined, color: _inkBlack),
                onPressed: () => _acceptInvite(context, provider),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.refreshActive,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                      children: [
                        const SizedBox(height: 12),
                        if (items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      'images/butler_logo_shopping_cart_empty.png',
                                    ),
                                    height: 200,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Your list is empty',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: _inkBlack,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add ingredients or type your own items.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _fadedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...sections
                              .where(
                                (s) =>
                                    s.items.isNotEmpty ||
                                    s.key == _CategoryKeys.my,
                              )
                              .map(
                                (section) => Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: _Section(
                                    section: section,
                                    categories: categories,
                                    onToggle: (item) {
                                      provider.toggleItem(
                                        item.id!,
                                        !item.isChecked,
                                      );
                                    },
                                    onChangeCategory: (item, category) {
                                      provider.updateCategory(
                                        item.id!,
                                        category,
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                _CategoryShelf(
                  categories: categories,
                  selected: _selectedCategory,
                  isBusy: provider.isMutating,
                  onSelect: (value) =>
                      setState(() => _selectedCategory = value),
                  onAdd: (name) async {
                    await provider.addCategory(name);
                    if (mounted) {
                      setState(() => _selectedCategory = name.trim());
                    }
                  },
                  onRename: provider.renameCategory,
                  onRemove: (name) async {
                    await provider.removeCategory(name);
                    if (!mounted) return;
                    if (_selectedCategory.trim().toLowerCase() ==
                        name.trim().toLowerCase()) {
                      setState(() => _selectedCategory = _CategoryKeys.my);
                    }
                  },
                ),
                _AddItemBar(
                  controller: _itemController,
                  isBusy: provider.isMutating,
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  onAdd: () async {
                    final text = _itemController.text.trim();
                    if (text.isEmpty) return;
                    await provider.addItem(text, category: _selectedCategory);
                    _itemController.clear();
                    setState(() => _selectedCategory = _CategoryKeys.my);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareList(
    BuildContext context,
    ShoppingListsProvider provider,
  ) async {
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

  Future<void> _acceptInvite(
    BuildContext context,
    ShoppingListsProvider provider,
  ) async {
    await showJoinListModal(context, provider);
  }
}

class _CategoryMeta {
  const _CategoryMeta({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String key;
  final String label;
  final IconData icon;
  final Color color;
}

class _SectionData {
  _SectionData({required this.meta});

  final _CategoryMeta meta;
  List<ShoppingItem> items = [];

  String get key => meta.key;
  int get uncheckedCount => items.where((i) => !i.isChecked).length;
}

class _CategoryKeys {
  static const my = 'my';
  static const other = 'other';
}

const Map<String, _CategoryMeta> _categoryMeta = {
  _CategoryKeys.my: _CategoryMeta(
    key: _CategoryKeys.my,
    label: 'My Items',
    icon: Icons.push_pin_outlined,
    color: _inkBlack,
  ),
  _CategoryKeys.other: _CategoryMeta(
    key: _CategoryKeys.other,
    label: 'Other',
    icon: Icons.category_outlined,
    color: Color(0xFF6B7280),
  ),
};

const int _overlayAlpha = 31; // 12% of 255

List<_SectionData> _buildSections(
  List<ShoppingItem> items,
  List<String> categories,
) {
  final Map<String, _SectionData> map = {
    for (final key in categories) key: _SectionData(meta: _metaFor(key)),
  };

  for (final item in items) {
    final key = item.category ?? _CategoryKeys.my;
    map.putIfAbsent(key, () => _SectionData(meta: _metaFor(key)));
    map[key]!.items.add(item);
  }

  return map.values.toList();
}

_CategoryMeta _metaFor(String key) {
  final meta = _categoryMeta[key];
  if (meta != null) return meta;
  return _CategoryMeta(
    key: key,
    label: key,
    icon: Icons.label_outline,
    color: _inkBlack,
  );
}

class _ListSwitcher extends StatelessWidget {
  const _ListSwitcher({
    required this.active,
    required this.lists,
    required this.onSelect,
    required this.onCreate,
  });

  final ShoppingList active;
  final List<ShoppingList> lists;
  final Future<void> Function(int listId) onSelect;
  final Future<void> Function(String name) onCreate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showShoppingListPickerModal(
        context: context,
        active: active,
        lists: lists,
        onSelect: onSelect,
        onCreate: onCreate,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active list',
                style: TextStyle(fontSize: 12, color: Color(0xFFA1A5AD)),
              ),
              Text(
                active.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _inkBlack,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down, color: _inkBlack),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.section,
    required this.categories,
    required this.onToggle,
    required this.onChangeCategory,
  });

  final _SectionData section;
  final List<String> categories;
  final void Function(ShoppingItem item) onToggle;
  final void Function(ShoppingItem item, String category) onChangeCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: section.meta.color.withAlpha(_overlayAlpha),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    section.meta.icon,
                    color: section.meta.color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  section.meta.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _inkBlack,
                  ),
                ),
              ],
            ),
            _CountBadge(
              count: section.uncheckedCount,
              color: section.meta.color,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (section.items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No items here yet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF9CA3AF),
              ),
            ),
          )
        else
          ...section.items.map(
            (item) => _ItemTile(
              item: item,
              accent: section.meta.color,
              categories: categories,
              onToggle: onToggle,
              onChangeCategory: onChangeCategory,
            ),
          ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.onToggle,
    required this.onChangeCategory,
    required this.categories,
    required this.accent,
  });

  final ShoppingItem item;
  final void Function(ShoppingItem item) onToggle;
  final void Function(ShoppingItem item, String category) onChangeCategory;
  final List<String> categories;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checked = item.isChecked;
    final categoryKey = item.category ?? _CategoryKeys.my;

    final categoryOptions = {
      ...categories,
      if (!categories.contains(categoryKey)) categoryKey,
    }.toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _panelLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onToggle(item),
        child: Row(
          children: [
            _CheckCircle(checked: checked, accent: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  decoration: checked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: checked ? const Color(0xFF9AA0AA) : _inkBlack,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'Change category',
              onSelected: (value) => onChangeCategory(item, value),
              itemBuilder: (context) => categoryOptions
                  .map(
                    (key) => PopupMenuItem<String>(
                      value: key,
                      child: Row(
                        children: [
                          Icon(
                            _metaFor(key).icon,
                            size: 18,
                            color: _metaFor(key).color,
                          ),
                          const SizedBox(width: 8),
                          Text(_metaFor(key).label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 20,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.checked, required this.accent});

  final bool checked;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeInOut,
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? accent.withAlpha(_overlayAlpha) : Colors.transparent,
        border: Border.all(
          color: checked ? accent : const Color(0xFF2F343E),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.check,
        size: 16,
        color: checked ? accent : Colors.transparent,
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(_overlayAlpha),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AddItemBar extends StatelessWidget {
  const _AddItemBar({
    required this.controller,
    required this.onAdd,
    required this.isBusy,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final TextEditingController controller;
  final Future<void> Function() onAdd;
  final bool isBusy;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final meta = _metaFor(selectedCategory);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          color: _panelLight,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Adding to',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _fadedText,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: meta.color.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meta.icon, size: 16, color: meta.color),
                      const SizedBox(width: 6),
                      Text(
                        meta.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _inkBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onAdd(),
                    decoration: InputDecoration(
                      hintText: 'Add item',
                      filled: true,
                      fillColor: _surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF2A2D36)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: _brandYellow,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: isBusy ? null : onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: _brandYellow,
                    foregroundColor: _inkBlack,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isBusy
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.add, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryShelf extends StatefulWidget {
  const _CategoryShelf({
    required this.categories,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
    required this.onRename,
    required this.onRemove,
    required this.isBusy,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;
  final Future<void> Function(String name) onAdd;
  final Future<void> Function(String from, String to) onRename;
  final Future<void> Function(String name) onRemove;
  final bool isBusy;

  @override
  State<_CategoryShelf> createState() => _CategoryShelfState();
}

class _CategoryShelfState extends State<_CategoryShelf> {
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.categories.isEmpty;
    return Container(
      // height: 92, // Removed fixed height to prevent overflow
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: _panelLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.w700, color: _inkBlack),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Add category',
                icon: const Icon(Icons.add, color: _inkBlack),
                onPressed: widget.isBusy
                    ? null
                    : () => _promptAddCategory(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (isEmpty)
            Text(
              'Tap + to create categories',
              style: TextStyle(color: _fadedText, fontSize: 12),
            )
          else
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = widget.categories[index];
                  final selected =
                      widget.selected.trim().toLowerCase() ==
                      cat.trim().toLowerCase();
                  return _CategoryChip(
                    label: cat,
                    selected: selected,
                    onTap: () => widget.onSelect(cat),
                    onLongPress: () => _showCategoryMenu(cat),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _promptAddCategory(BuildContext context) async {
    _addController.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New category',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'e.g. Drinks'),
                onSubmitted: (_) => _save(ctx),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => _save(ctx),
                style: FilledButton.styleFrom(
                  backgroundColor: _inkBlack,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCategoryMenu(String cat) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final renameController = TextEditingController(text: cat);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: renameController,
                decoration: const InputDecoration(labelText: 'Rename'),
                onSubmitted: (_) => _rename(ctx, cat, renameController.text),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton(
                    onPressed: () => _rename(ctx, cat, renameController.text),
                    style: FilledButton.styleFrom(
                      backgroundColor: _inkBlack,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Rename'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => _remove(ctx, cat),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save(BuildContext ctx) async {
    final name = _addController.text.trim();
    if (name.isEmpty) return;
    await widget.onAdd(name);
    if (ctx.mounted) Navigator.of(ctx).pop();
  }

  Future<void> _rename(BuildContext ctx, String from, String to) async {
    final trimmed = to.trim();
    if (trimmed.isEmpty || trimmed == from) return;
    await widget.onRename(from, trimmed);
    if (ctx.mounted) Navigator.of(ctx).pop();
  }

  Future<void> _remove(BuildContext ctx, String name) async {
    await widget.onRemove(name);
    if (ctx.mounted) Navigator.of(ctx).pop();
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _inkBlack : _surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _inkBlack : const Color(0xFFCED2DA),
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tag, size: 16, color: _brandYellow),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? _surfaceLight : _inkBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
