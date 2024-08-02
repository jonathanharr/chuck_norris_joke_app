import 'package:flutter/material.dart';
import 'package:chuck_norris_joke_app/app_state.dart';
import 'package:provider/provider.dart';

class QueryPage extends StatelessWidget {
  final Function onQueryFunction;

  const QueryPage({super.key, required this.onQueryFunction});

  void fetchWithQuery() {
    onQueryFunction();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var query = "";

    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Input your query as a search term:'),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                    onChanged: (value) {
                      query = value;
                    })),
            ElevatedButton(
              onPressed: () {
                if (View.of(context).viewInsets.bottom > 0.0) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                appState.setCurrentJoke("");
                appState.setQuery(query);
                fetchWithQuery();
              },
              child: const Text('Fetch with Query'),
            ),
          ],
        ),
      );
    });
  }
}
