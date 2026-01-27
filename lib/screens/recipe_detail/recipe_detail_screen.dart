import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_butler_client/recipe_butler_client.dart';

import '../../providers/recipes_provider.dart';
import '../../widgets/loading_widget.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? _fullRecipe;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final provider = context.read<RecipesProvider>();
    final fetched = await provider.fetchRecipe(widget.recipe.id!);
    setState(() {
      _fullRecipe = fetched ?? widget.recipe;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _fullRecipe ?? widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final provider = context.read<RecipesProvider>();
              final navigator = Navigator.of(context);
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete recipe?'),
                  content: const Text(
                    'This will remove the recipe permanently.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await provider.delete(recipe.id!);
                navigator.pop(true);
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const LoadingWidget(message: 'Loading recipe...')
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.link, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          recipe.sourceUrl ?? 'No source URL',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Created ${recipe.createdAt.toLocal().toString()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Ingredient list coming soon.'),
                  const SizedBox(height: 24),
                  Text(
                    'Steps',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Steps coming soon.'),
                ],
              ),
            ),
    );
  }
}
