import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/collections_provider.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../widgets/loading_widget.dart';

class CollectionsTab extends StatelessWidget {
  const CollectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),
      body: Consumer<CollectionsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const LoadingWidget();
          if (provider.error != null) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: provider.loadCollections,
            );
          }
          if (provider.collections.isEmpty) {
            return const EmptyStateWidget(
              title: 'No collections',
              subtitle: 'Group recipes together for easier sharing.',
              icon: Icons.folder_shared_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.collections.length,
            itemBuilder: (_, index) {
              final collection = provider.collections[index];
              return Card(
                child: ListTile(
                  title: Text('${collection['name'] ?? 'Collection'}'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: open create collection dialog.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
