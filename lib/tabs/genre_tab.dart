import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';

import '../screens/genre_movie_screen.dart';

class GenresTab extends StatelessWidget {
  final Future<List<Movie>> allMovies;

  const GenresTab({Key? key, required this.allMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: allMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading genres", style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No genres available", style: TextStyle(color: Colors.white)));
        }

        final movies = snapshot.data!;
        final genres = movies
            .expand((movie) => movie.genres)
            .toSet()
            .toList();

        return ListView.builder(
          itemCount: genres.length,
          itemBuilder: (context, index) {
            final genre = genres[index];
            return ListTile(
              title: Text(genre, style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                final genreMovies = movies.where((movie) => movie.genres.contains(genre)).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GenreMoviesScreen(genre: genre, movies: genreMovies),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
