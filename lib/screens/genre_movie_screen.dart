import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details_screen.dart';

class GenreMoviesScreen extends StatelessWidget {
  final String genre;
  final List<Movie> movies;

  const GenreMoviesScreen({required this.genre, required this.movies, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Movies'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    movie: movie,
                  ),
                ),
              );
            },
            child: GridTile(
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(movie.title),
                subtitle: Text(
                    'Rating: ${movie.rating} | Genres: ${movie.genres.join(', ')}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
