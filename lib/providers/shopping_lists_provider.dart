import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shopping_list_service.dart';

class ShoppingListsProvider extends ChangeNotifier {
  ShoppingListsProvider({ShoppingListService? shoppingListService})
    : _shoppingListService = shoppingListService ?? ShoppingListService();

  final ShoppingListService _shoppingListService;

  static const _defaultCategory = 'my';
  static const _prefsCategoriesKey = 'shopping_categories_v1';

  String _userKey = '';
  bool _loading = false;
  bool _mutating = false;
  List<ShoppingList> _lists = [];
  ShoppingList? _activeList;
  final Map<int, List<ShoppingItem>> _items = {};
  List<String> _categories = [_defaultCategory];
  bool _categoriesLoaded = false;
  String? _error;

  bool get isLoading => _loading;
  bool get isMutating => _mutating;
  List<ShoppingList> get lists => _lists;
  ShoppingList? get activeList => _activeList;
  List<ShoppingItem> get activeItems =>
      _activeList?.id == null ? [] : (_items[_activeList!.id!] ?? []);
  List<String> get categories => _categories;
  String? get error => _error;

  void setUser(String userKey) {
    _userKey = userKey;
    _lists = [];
    _activeList = null;
    _items.clear();
    _categories = [_defaultCategory];
    _categoriesLoaded = false;
    _error = null;
  }

  Future<void> loadCategories() async {
    if (_categoriesLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsCategoriesKey) ?? [];
    _categories = [_defaultCategory, ..._sanitizeList(stored)];
    _categoriesLoaded = true;
    notifyListeners();
  }

  Future<void> ensureActiveList() async {
    if (_userKey.isEmpty) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _lists = await _shoppingListService.listShoppingLists(_userKey);
      if (_lists.isEmpty) {
        final created = await _shoppingListService.createShoppingList(
          _userKey,
          'My shopping list',
        );
        _lists = [created];
      }
      _activeList ??= _lists.first;
      await _loadItems(_activeList!.id!);
    } catch (e) {
      _error = 'Could not load shopping list';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshActive() async {
    if (_activeList?.id == null) return;
    await _loadItems(_activeList!.id!);
  }

  Future<void> _loadItems(int listId) async {
    try {
      _items[listId] = await _shoppingListService.listItems(_userKey, listId);
      _items[listId] = _sorted(_items[listId]!);
      await _absorbCategoriesFromItems(_items[listId]!);
    } catch (e) {
      _error = 'Could not load items';
    } finally {
      notifyListeners();
    }
  }

  Future<void> setActiveList(int listId) async {
    if (_activeList?.id == listId) return;
    final target = _lists.firstWhere(
      (l) => l.id == listId,
      orElse: () => _activeList ?? _lists.first,
    );
    _activeList = target;
    _loading = true;
    notifyListeners();
    await _loadItems(listId);
    _loading = false;
    notifyListeners();
  }

  Future<void> createList(String name) async {
    _mutating = true;
    notifyListeners();
    try {
      final created = await _shoppingListService.createShoppingList(
        _userKey,
        name,
      );
      _lists = [created, ..._lists];
      _activeList = created;
      await _loadItems(created.id!);
    } catch (e) {
      _error = 'Could not create list';
    } finally {
      _mutating = false;
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String text, {String? category}) async {
    if (_activeList?.id == null) return;
    _mutating = true;
    notifyListeners();
    try {
      debugPrint(
        '[Shopping] addItem start text="$text" category=${category ?? _defaultCategory} list=${_activeList!.id}',
      );
      final item = await _shoppingListService.addItem(
        _userKey,
        _activeList!.id!,
        text,
        category: category,
      );
      final listId = _activeList!.id!;
      _items[listId] = _sorted([item, ...(_items[listId] ?? [])]);
      debugPrint(
        '[Shopping] addItem success id=${item.id} total=${_items[listId]!.length}',
      );
    } catch (e) {
      _error = 'Could not add item';
      debugPrint('[Shopping] addItem error $e');
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> toggleItem(int itemId, bool checked) async {
    if (_activeList?.id == null) return;
    _mutating = true;
    notifyListeners();
    final listId = _activeList!.id!;
    try {
      final updated = await _shoppingListService.toggleItem(
        _userKey,
        itemId,
        checked,
      );
      if (updated != null) {
        _items[listId] = _sorted(
          (_items[listId] ?? [])
              .map((i) => i.id == itemId ? updated : i)
              .toList(),
        );
      }
    } catch (e) {
      _error = 'Could not update item';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(int itemId, String category) async {
    if (_activeList?.id == null) return;
    _mutating = true;
    notifyListeners();
    final listId = _activeList!.id!;
    try {
      final updated = await _shoppingListService.updateCategory(
        _userKey,
        itemId,
        category,
      );
      if (updated != null) {
        _items[listId] = _sorted(
          (_items[listId] ?? [])
              .map((i) => i.id == itemId ? updated : i)
              .toList(),
        );
      }
    } catch (e) {
      _error = 'Could not move item';
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    final sanitized = _sanitizeCategory(name);
    if (sanitized == null || _containsCategory(sanitized)) return;
    _categories = [..._categories, sanitized];
    await _persistCategories();
    notifyListeners();
  }

  Future<void> renameCategory(String from, String to) async {
    final sanitized = _sanitizeCategory(to);
    if (sanitized == null || _isDefault(from)) return;
    final index = _categories.indexWhere(
      (c) => _normalize(c) == _normalize(from),
    );
    if (index == -1) return;
    if (_containsCategory(sanitized)) return;
    _mutating = true;
    notifyListeners();
    try {
      final oldValue = _categories[index];
      _categories[index] = sanitized;
      await _persistCategories();
      await _rewriteCategoryInItems(oldValue, sanitized);
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> removeCategory(String name) async {
    if (_isDefault(name)) return;
    _mutating = true;
    notifyListeners();
    try {
      final removed = _categories
          .where((c) => _normalize(c) != _normalize(name))
          .toList();
      _categories = removed.isEmpty ? [_defaultCategory] : removed;
      await _persistCategories();
      await _rewriteCategoryInItems(name, _defaultCategory);
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<String?> createShareToken({required String role}) async {
    if (_activeList?.id == null) return null;
    try {
      final invite = await _shoppingListService.createInvite(
        _userKey,
        _activeList!.id!,
        role,
      );
      return invite.token;
    } catch (e) {
      _error = 'Could not create invite';
      notifyListeners();
      return null;
    }
  }

  Future<bool> acceptInvite(String token) async {
    _mutating = true;
    notifyListeners();
    try {
      final listId = await _shoppingListService.acceptInvite(_userKey, token);
      if (listId == null) {
        _error = 'Invite not found or expired';
        return false;
      }
      _lists = await _shoppingListService.listShoppingLists(_userKey);
      _activeList = _lists.firstWhere(
        (l) => l.id == listId,
        orElse: () => _activeList ?? _lists.first,
      );
      await _loadItems(listId);
      return true;
    } catch (e) {
      _error = 'Could not accept invite';
      return false;
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  List<ShoppingItem> _sorted(List<ShoppingItem> items) {
    final list = [...items];
    list.sort((a, b) {
      if (a.isChecked != b.isChecked) {
        return a.isChecked ? 1 : -1;
      }
      final aId = a.id ?? 0;
      final bId = b.id ?? 0;
      return aId.compareTo(bId);
    });
    return list;
  }

  Future<void> _persistCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsCategoriesKey,
      _categories
          .where((c) => !_isDefault(c))
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList(),
    );
  }

  Future<void> _rewriteCategoryInItems(String from, String to) async {
    final listId = _activeList?.id;
    if (listId == null) return;
    final current = [...?_items[listId]];
    bool changed = false;
    for (var i = 0; i < current.length; i++) {
      final item = current[i];
      final currentCat = _normalize(item.category ?? _defaultCategory);
      if (currentCat != _normalize(from)) continue;
      if (item.id == null) continue;
      final updated = await _shoppingListService.updateCategory(
        _userKey,
        item.id!,
        to,
      );
      if (updated != null) {
        current[i] = updated;
        changed = true;
      }
    }
    if (changed) {
      _items[listId] = _sorted(current);
    }
  }

  Future<void> _absorbCategoriesFromItems(List<ShoppingItem> items) async {
    var updated = false;
    for (final item in items) {
      final cat = item.category?.trim();
      if (cat == null || cat.isEmpty) continue;
      if (!_containsCategory(cat)) {
        _categories.add(cat);
        updated = true;
      }
    }
    if (updated) {
      await _persistCategories();
    }
  }

  String? _sanitizeCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  bool _containsCategory(String name) {
    final normalized = _normalize(name);
    return _categories.any((c) => _normalize(c) == normalized);
  }

  bool _isDefault(String value) => _normalize(value) == _defaultCategory;

  String _normalize(String value) => value.trim().toLowerCase();

  List<String> _sanitizeList(List<String> values) {
    final result = <String>[];
    for (final value in values) {
      final sanitized = _sanitizeCategory(value);
      if (sanitized == null) continue;
      if (_containsIn(result, sanitized)) continue;
      result.add(sanitized);
    }
    return result;
  }

  bool _containsIn(List<String> list, String value) {
    final normalized = _normalize(value);
    return list.any((c) => _normalize(c) == normalized);
  }
}
