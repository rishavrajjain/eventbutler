import 'package:flutter/material.dart';

import '../../shopping_list_detail/shopping_list_detail_screen.dart';

class ShoppingListsTab extends StatelessWidget {
  const ShoppingListsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Shopping list detail is now the main tab experience.
    return const ShoppingListDetailScreen();
  }
}
