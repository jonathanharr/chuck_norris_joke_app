import 'chuck_norris_api.dart';
import 'joke.dart';

class ChuckNorrisService {
  final _api = ChuckNorrisApi();

  Future<Joke> getRandomJoke(String category) async {
    return _api.getRandomJoke(category);
  }

  Future<Joke> getJokeByQuery(String query) async {
    return _api.getJokeByQuery(query);
  }

  Future<List<String>> getCategories() async {
    return _api.getCategories();
  }
}