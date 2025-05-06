import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/model/movie.dart';

class FavoriteManager with ChangeNotifier {
  List<Movie> favorites = [];

  Future<String> _getStorageKey() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    return 'favorites_${user.uid}';
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getStorageKey();
      final jsonList = prefs.getStringList(key) ?? [];

      favorites = jsonList.map((json) => Movie.fromJson(jsonDecode(json))).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load favorites: $e");
    }
  }

  Future<void> addFavorite(Movie movie) async {
    if (!isFavorite(movie)) {
      favorites.add(movie);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    favorites.removeWhere((m) => m.id == movie.id);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return favorites.any((m) => m.id == movie.id);
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getStorageKey();
      final jsonList = favorites.map((movie) => jsonEncode(movie.toJson())).toList();
      await prefs.setStringList(key, jsonList);
    } catch (e) {
      debugPrint("Failed to save favorites: $e");
    }
  }

  Future<void> clearFavoritesForUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getStorageKey();
      await prefs.remove(key);
      favorites.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to clear favorites: $e");
    }
  }
}
