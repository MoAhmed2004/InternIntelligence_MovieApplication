import 'package:movie_app/model/movie.dart';

class FavoriteManager {
  static final List<Movie> _favorites = [];

  static List<Movie> get favorites => _favorites;

  static bool isFavorite(Movie movie) {
    return _favorites.any((fav) => fav.id == movie.id);
  }

  static void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      _favorites.removeWhere((fav) => fav.id == movie.id);
    } else {
      _favorites.add(movie);
    }
  }
}
