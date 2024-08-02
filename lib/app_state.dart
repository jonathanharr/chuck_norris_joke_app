import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier 
{
  var favorites = <String>[];
  String currentJoke = "";
  String query = "";
  List<String>? categories;

  AppState() {
    _initFavorites();
  }

  String getQueryReset()
  {
    var temp = query;
    query = "";
    return temp;
  }

  void setQuery(String query) 
  {
    this.query = query;
  }

  void setCurrentJoke(String joke) 
  {
    currentJoke = joke;
  }

  void setCategories(List<String> categories) 
  {
    this.categories = categories;
  }

  void toggleFavorite(String joke) 
  {
    if (favorites.contains(joke)) 
    {
      favorites.remove(joke);
    } 
    else 
    {
      favorites.add(joke);
    }
    saveFavorites();

    notifyListeners();
  }

  bool isFavorite(String joke) 
  {
    return favorites.contains(joke);
  }

  void reorderFavorites(int oldIndex, int newIndex) 
  {
    if (newIndex > oldIndex) 
    {
      newIndex -= 1;
    }
    final joke = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, joke);
    print(favorites);
    saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(favorites);
    await prefs.setString('favorites', encodedData);
  }

  Future<void> _initFavorites() async {
    await loadFavorites();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('favorites');

    if (encodedData != null) {
      final List<dynamic> decodedList = jsonDecode(encodedData);
      favorites = List<String>.from(decodedList);
      notifyListeners();
    }
  }
}