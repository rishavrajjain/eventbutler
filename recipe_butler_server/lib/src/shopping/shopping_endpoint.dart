import 'dart:math';

import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ShoppingEndpoint extends Endpoint {
  String _channelName(int listId) => 'shopping_list_$listId';

  /// Create a shopping list for the user.
  Future<ShoppingList> createShoppingList(
    Session session,
    String userKey,
    String name,
  ) async {
    final userId = _requireUser(userKey);
    final list = ShoppingList(
      ownerUserId: userId,
      name: name,
      createdAt: DateTime.now().toUtc(),
    );
    final created = await ShoppingList.db.insertRow(session, list);
    // Owner membership
    await ShoppingListMember.db.insertRow(
      session,
      ShoppingListMember(
        shoppingListId: created.id!,
        userId: userId,
        role: 'owner',
      ),
    );
    return created;
  }

  /// List shopping lists the user owns or is a member of.
  Future<List<ShoppingList>> listMyShoppingLists(
    Session session,
    String userKey,
  ) async {
    final userId = _requireUser(userKey);
    // Fetch via membership or ownership
    final memberListIds = await ShoppingListMember.db.find(
      session,
      where: (m) => m.userId.equals(userId),
    );
    final ids = memberListIds.map((m) => m.shoppingListId).toSet();

    return ShoppingList.db.find(
      session,
      where: (l) =>
          l.ownerUserId.equals(userId) |
          (ids.isNotEmpty ? l.id.inSet(ids) : Constant.bool(false)),
      orderBy: (l) => l.createdAt,
      orderDescending: true,
    );
  }

  /// Add a shopping item.
  Future<ShoppingItem> addShoppingItem(
    Session session,
    String userKey,
    int listId,
    String text,
    String? category,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanEdit(session, userId, listId);
    final item = ShoppingItem(
      shoppingListId: listId,
      text: text,
      isChecked: false,
      category: category ?? 'my',
      updatedAt: DateTime.now().toUtc(),
      updatedByUserId: userId,
    );
    final created = await ShoppingItem.db.insertRow(session, item);
    await _postEvent(
      session,
      listId,
      ShoppingListEvent(
        listId: listId,
        type: 'itemAdded',
        item: created,
        itemId: created.id,
        category: created.category,
        updatedByUserId: userId,
        sentAt: DateTime.now().toUtc(),
      ),
    );
    return created;
  }

  /// Toggle an item.
  Future<ShoppingItem?> toggleShoppingItem(
    Session session,
    String userKey,
    int itemId,
    bool isChecked,
  ) async {
    final userId = _requireUser(userKey);
    final item = await ShoppingItem.db.findById(session, itemId);
    if (item == null) return null;
    await _assertCanEdit(session, userId, item.shoppingListId);
    final updated = item.copyWith(
      isChecked: isChecked,
      updatedAt: DateTime.now().toUtc(),
      updatedByUserId: userId,
    );
    await ShoppingItem.db.updateRow(session, updated);
    await _postEvent(
      session,
      item.shoppingListId,
      ShoppingListEvent(
        listId: item.shoppingListId,
        type: 'itemToggled',
        itemId: item.id,
        isChecked: isChecked,
        category: updated.category,
        updatedByUserId: userId,
        sentAt: DateTime.now().toUtc(),
      ),
    );
    return updated;
  }

  /// Update an item's category.
  Future<ShoppingItem?> updateShoppingItemCategory(
    Session session,
    String userKey,
    int itemId,
    String category,
  ) async {
    final userId = _requireUser(userKey);
    final item = await ShoppingItem.db.findById(session, itemId);
    if (item == null) return null;
    await _assertCanEdit(session, userId, item.shoppingListId);

    final updated = item.copyWith(
      category: category,
      updatedAt: DateTime.now().toUtc(),
      updatedByUserId: userId,
    );
    await ShoppingItem.db.updateRow(session, updated);

    await _postEvent(
      session,
      item.shoppingListId,
      ShoppingListEvent(
        listId: item.shoppingListId,
        type: 'itemUpdated',
        itemId: item.id,
        category: category,
        updatedByUserId: userId,
        sentAt: DateTime.now().toUtc(),
      ),
    );
    return updated;
  }

  /// List items for a list.
  Future<List<ShoppingItem>> listShoppingItems(
    Session session,
    String userKey,
    int listId,
  ) async {
    final userId = _requireUser(userKey);
    await _assertCanView(session, userId, listId);
    return ShoppingItem.db.find(
      session,
      where: (i) => i.shoppingListId.equals(listId),
      orderBy: (i) => i.id,
    );
  }

  /// Subscribe to realtime updates for a shopping list.
  Stream<ShoppingListEvent> subscribeShoppingList(
    Session session,
    String userKey,
    int listId,
  ) async* {
    final userId = _requireUser(userKey);
    await _assertCanView(session, userId, listId);
    yield* session.messages.createStream<ShoppingListEvent>(
      _channelName(listId),
    );
  }

  /// Create an invite token for a list.
  Future<Invite> createInvite(
    Session session,
    String userKey,
    int listId,
    String role,
  ) async {
    final userId = _requireUser(userKey);
    await _assertIsOwner(session, userId, listId);
    final token = _generateToken();
    final invite = Invite(
      targetType: 'shoppingList',
      targetId: listId,
      token: token,
      role: role,
      expiresAt: DateTime.now().toUtc().add(const Duration(days: 3)),
      acceptedAt: null,
    );
    return Invite.db.insertRow(session, invite);
  }

  /// Accept an invite; returns list id.
  Future<int?> acceptInvite(
    Session session,
    String userKey,
    String token,
  ) async {
    final userId = _requireUser(userKey);
    final invite = await Invite.db.findFirstRow(
      session,
      where: (i) => i.token.equals(token),
    );
    if (invite == null) return null;
    if (invite.expiresAt != null &&
        invite.expiresAt!.isBefore(DateTime.now().toUtc())) {
      return null;
    }
    // Upsert membership
    final existing = await ShoppingListMember.db.findFirstRow(
      session,
      where: (m) =>
          m.shoppingListId.equals(invite.targetId) & m.userId.equals(userId),
    );
    if (existing == null) {
      await ShoppingListMember.db.insertRow(
        session,
        ShoppingListMember(
          shoppingListId: invite.targetId,
          userId: userId,
          role: invite.role,
        ),
      );
    } else {
      await ShoppingListMember.db.updateRow(
        session,
        existing.copyWith(role: invite.role),
      );
    }
    await Invite.db.updateRow(
      session,
      invite.copyWith(acceptedAt: DateTime.now().toUtc()),
    );
    return invite.targetId;
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

  Future<void> _assertIsOwner(
    Session session,
    String userId,
    int listId,
  ) async {
    final list = await ShoppingList.db.findById(session, listId);
    if (list == null || list.ownerUserId != userId) {
      throw sp.AccessDeniedException(message: 'Owner only');
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

  String _generateToken() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random.secure();
    return List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
