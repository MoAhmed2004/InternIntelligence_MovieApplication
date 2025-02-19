import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/genre_movie_screen.dart';

class GenresTab extends StatelessWidget {
  final Future<List<Movie>> allMovies;

  const GenresTab({required this.allMovies, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else {
          final movies = snapshot.data as List<Movie>;
          final genres = movies.expand((movie) => movie.genres).toSet().toList();
          return ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              final genreMovies = movies.where((movie) => movie.genres.contains(genre)).toList();
              return ListTile(
                title: Text(genre),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenreMoviesScreen(genre: genre, movies: genreMovies),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}