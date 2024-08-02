import 'package:flutter/material.dart';
import 'package:chuck_norris_joke_app/app_state.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    var appState = context.watch<AppState>();
    var favorites = appState.favorites;
    if (favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet'),
      );
    }

    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return Container(
          key: ValueKey(favorites[index]),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.05),
            border: Border.all(
              color: colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(favorites[index]),
            trailing: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      appState.toggleFavorite(favorites[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        appState.reorderFavorites(oldIndex, newIndex);
      },
    );
  }
}
