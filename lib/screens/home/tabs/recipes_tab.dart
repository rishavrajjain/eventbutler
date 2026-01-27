import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/recipes_provider.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/recipe_card.dart';
import '../../recipe_detail/recipe_detail_screen.dart';

class RecipesTab extends StatefulWidget {
  const RecipesTab({super.key});

  @override
  State<RecipesTab> createState() => _RecipesTabState();
}

class _RecipesTabState extends State<RecipesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<RecipesProvider>().loadRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Import from URL',
            onPressed: _openImportSheet,
          ),
        ],
      ),
      body: Consumer<RecipesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const LoadingWidget();
          if (provider.error != null) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: provider.loadRecipes,
            );
          }
          if (provider.recipes.isEmpty) {
            return const EmptyStateWidget(
              title: 'No recipes yet',
              subtitle: 'Import or add your first recipe to begin.',
              icon: Icons.restaurant_menu,
            );
          }
          return RefreshIndicator(
            onRefresh: provider.loadRecipes,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final recipe = provider.recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemCount: provider.recipes.length,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddRecipeSheet,
        label: const Text('Add Recipe'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddRecipeSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddRecipeSheet(),
    );
  }

  Future<void> _openImportSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ImportRecipeSheet(),
    );
  }
}

class _AddRecipeSheet extends StatefulWidget {
  const _AddRecipeSheet();

  @override
  State<_AddRecipeSheet> createState() => _AddRecipeSheetState();
}

class _AddRecipeSheetState extends State<_AddRecipeSheet> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipesProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add a recipe',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Lemon Garlic Chicken',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Source URL (optional)',
                  hintText: 'https://example.com/recipe',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: provider.isMutating
                    ? null
                    : () async {
                        final navigator = Navigator.of(context);
                        final title = _titleController.text.trim();
                        final url = _urlController.text.trim();
                        if (title.isEmpty) return;
                        await provider.create(
                          title,
                          sourceUrl: url.isEmpty ? null : url,
                        );
                        if (!mounted) return;
                        navigator.pop();
                      },
                child: provider.isMutating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportRecipeSheet extends StatefulWidget {
  const _ImportRecipeSheet();

  @override
  State<_ImportRecipeSheet> createState() => _ImportRecipeSheetState();
}

class _ImportRecipeSheetState extends State<_ImportRecipeSheet> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipesProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Import from URL',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Recipe URL',
                  hintText: 'https://example.com/recipe',
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.isMutating
                    ? null
                    : () async {
                        final navigator = Navigator.of(context);
                        final url = _urlController.text.trim();
                        if (url.isEmpty) return;
                        await provider.importFromUrl(url);
                        if (!mounted) return;
                        navigator.pop();
                      },
                child: provider.isMutating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Import'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
