import 'package:flutter/material.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../providers/shopping_lists_provider.dart';

const _inkBlack = Color(0xFF111217);

Future<void> showShoppingListPickerModal({
  required BuildContext context,
  ShoppingList? active,
  required List<ShoppingList> lists,
  required Future<void> Function(int listId) onSelect,
  required Future<void> Function(String name) onCreate,
}) async {
  final nameController = TextEditingController();
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your shopping lists',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...lists.map(
              (list) => ListTile(
                leading: Icon(
                  (active != null && list.id == active.id)
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(list.name),
                onTap: () async {
                  await onSelect(list.id!);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
            ),
            const Divider(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Create new list',
                hintText: 'Weekend groceries',
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                await onCreate(name);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: _inkBlack,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create and switch'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showJoinListModal(
  BuildContext context,
  ShoppingListsProvider provider,
) async {
  final tokenController = TextEditingController();
  await showModalBottomSheet(
    context: context,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Join a list', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: tokenController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Invite token',
                hintText: 'ABCD1234',
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: provider.isMutating
                  ? null
                  : () async {
                      final token = tokenController.text.trim();
                      if (token.isEmpty) return;
                      final ok = await provider.acceptInvite(token);
                      if (ctx.mounted && ok) Navigator.of(ctx).pop();
                    },
              style: FilledButton.styleFrom(
                backgroundColor: _inkBlack,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: provider.isMutating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Join list'),
            ),
          ],
        ),
      );
    },
  );
}
