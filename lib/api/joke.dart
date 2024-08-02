class JokeList {
  final int total;
  final List<Joke> result;

  List<Joke> get getJokes => result;

  JokeList({
    required this.total,
    required this.result,
  });

  factory JokeList.fromJson(Map<String, dynamic> json) {
    return JokeList(
      total: json['total'],
      result: List<Joke>.from(json['result'].map((joke) => Joke.fromJson(joke))),
    );
  }
}

class Joke {
  final List<String> categories;
  final String createdAt;
  final String iconUrl;
  final String id;
  final String updatedAt;
  final String url;
  final String value;

  Joke({
    required this.categories,
    required this.createdAt,
    required this.iconUrl,
    required this.id,
    required this.updatedAt,
    required this.url,
    required this.value,
  });

  String get getJoke => value;

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      categories: List<String>.from(json['categories']),
      createdAt: json['created_at'],
      iconUrl: json['icon_url'],
      id: json['id'],
      updatedAt: json['updated_at'],
      url: json['url'],
      value: json['value'],
    );
  }
}