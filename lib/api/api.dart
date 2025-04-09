import 'dart:convert';
import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _baseUrl = "https://api.themoviedb.org/3";
  static const _apiKey = "?api_key=${Constant.apiKey}";

  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse("$_baseUrl$endpoint$_apiKey"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> getTrending() => _fetchMovies("/trending/movie/day");
  Future<List<Movie>> getTopRated() => _fetchMovies("/movie/top_rated");
  Future<List<Movie>> getUpComing() => _fetchMovies("/movie/upcoming");
  Future<List<Movie>> getAllMovies() => _fetchMovies("/discover/movie");

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(Uri.parse("$_baseUrl/search/movie$_apiKey&query=$query"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData == null || decodedData["results"] == null) return [];
      return (decodedData["results"] as List).map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<String?> getTrailerUrl(int movieId) async {
    final url = "$_baseUrl/movie/$movieId/videos$_apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      final trailer = decodedData.firstWhere(
            (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      return trailer != null ? "https://www.youtube.com/watch?v=${trailer['key']}" : null;
    }
    return null;
  }
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await http.get(Uri.parse("$_baseUrl/movie/$movieId/similar$_apiKey"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.FromJson(movie)).toList();
    } else {
      throw Exception("Failed to load similar movies");
    }
  }


  Future<List<Map<String, String>>> getCast(int movieId) async {
    final url = "$_baseUrl/movie/$movieId/credits$_apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final castList = jsonDecode(response.body)['cast'] as List;

      return castList
          .where((actor) => actor['profile_path'] != null)
          .map((actor) => {
        'name': actor['name'].toString(),
        'character': actor['character']?.toString() ?? 'Unknown role',
        'photo': "${Constant.imageUrl}${actor['profile_path']}",
      })
          .toList();
    } else {
      throw Exception("Failed to load cast");
    }
  }


}