import 'dart:convert';
import 'dart:math';
import 'joke.dart';
import 'package:http/http.dart' as http;

class ChuckNorrisApi {
  static const String baseUrl = 'https://api.chucknorris.io/jokes';

  Future<Joke> getRandomJoke(String category) async {
    String url = category == "" ? '$baseUrl/random' : '$baseUrl/random?category=$category';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<Joke> getJokeByQuery(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    if (response.statusCode == 200) {
      JokeList jokeList = JokeList.fromJson(json.decode(response.body));
      var rng = Random();
      var randomInt = rng.nextInt(jokeList.total);
      return jokeList.getJokes[randomInt];
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  } 
}