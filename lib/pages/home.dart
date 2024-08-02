import 'package:flutter/material.dart';
import 'package:chuck_norris_joke_app/app_state.dart';
import 'package:provider/provider.dart';
import '../api/chuck_norris_service.dart';
import '../api/joke.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chuckNorrisService = ChuckNorrisService();
  List<String>? _categories;
  String _currentJoke = "";
  String _selectedCategory = "";
  bool _isLoading = true;

  late AppState appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appState = Provider.of<AppState>(context, listen: false);
    loadCurrentJoke();
  }

  Future<void> loadCurrentJoke() async {
    if (appState.currentJoke != "") {
      _currentJoke = appState.currentJoke;
      _categories = appState.categories;
      _isLoading = false;
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_categories == null) {
      await loadCategories();
      _selectedCategory = _categories![0];
    }

    var query = appState.getQueryReset();
    Joke? receiveJoke;
    if (query != "") {
      receiveJoke = await _chuckNorrisService.getJokeByQuery(query);
    } else {
      receiveJoke = await _chuckNorrisService.getRandomJoke(_selectedCategory);
    }

    _currentJoke = receiveJoke.getJoke;
    appState.setCurrentJoke(_currentJoke);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadCategories() async {
    _categories = List<String>.empty(growable: true);
    _categories!.add('');
    _categories!.addAll(await _chuckNorrisService.getCategories());
    appState.setCategories(_categories!);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          SizedBox(
            height: constraints.maxHeight * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
              child: _isLoading
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('Loading joke...')
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        JokeCard(
                            joke: _currentJoke,
                            onFavorite: () {
                              appState.toggleFavorite(_currentJoke);
                            })
                      ],
                    ),
            ),
          ),
          SizedBox(
              width: constraints.maxWidth * 0.7,
              child: Column(children: [
                const Text('Select a category from the dropdown'),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  items: _categories!
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ])),
          ElevatedButton(
            onPressed: () {
              appState.setCurrentJoke("");
              loadCurrentJoke();
            },
            child: const Text('Get random joke'),
          )
        ]);
      },
    );
  }
}

class JokeCard extends StatelessWidget {
  final String joke;
  final VoidCallback onFavorite;

  const JokeCard({super.key, required this.joke, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    IconData icon =
        appState.isFavorite(joke) ? Icons.favorite : Icons.favorite_border;
    return Card(
        child: Row(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 165,
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(joke,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onFavorite,
          ),
        )
      ],
    ));
  }
}
