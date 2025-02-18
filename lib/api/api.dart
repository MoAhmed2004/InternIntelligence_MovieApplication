import 'dart:convert';

import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';
import 'package:http/http.dart' as http;
class Api {
  static const _trendingUrl = "https://api.themoviedb.org/3/trending/movie/day?api_key=${Constant.apiKey}";
  static const _topRatedUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=${Constant.apiKey}";
  static const _upComingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=${Constant.apiKey}";
  static const _searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=${Constant.apiKey}&query=";

  Future<List<Movie>> getTrending() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> getTopRated() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> getUpComing() async {
    final response = await http.get(Uri.parse(_upComingUrl));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
final response = await http.get(Uri.parse("$_searchUrl${query ?? ''}"));    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}