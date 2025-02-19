import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final Api api = Api();

  SearchResultsScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
        ),
        body: FutureBuilder(
          future: api.searchMovies(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            } else
            if (!snapshot.hasData || (snapshot.data as List<Movie>).isEmpty) {
              return const Center(child: Text('No results found'));
            } else {
              final data = snapshot.data as List<Movie>;
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final movie = data[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsScreen(
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
                      // Placeholder for missing image
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(movie.title),
                      ),
                    ),
                  );
                },
              );
            }
            },
        )
    );
  }
  }
