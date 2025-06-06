import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details_screen.dart';

class UpComingMoviesScreen extends StatefulWidget {
  const UpComingMoviesScreen({Key? key}) : super(key: key);
  static const String routeName = "up_coming_screen";

  @override
  _UpComingMoviesScreenState createState() => _UpComingMoviesScreenState();
}

class _UpComingMoviesScreenState extends State<UpComingMoviesScreen> {
  final Api api = Api();
  late Future<List<Movie>> upComingMovies;

  @override
  void initState() {
    super.initState();
    upComingMovies = api.getUpComing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UpComing Movies'),
      ),
      body: FutureBuilder(
        future: upComingMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            final movies = snapshot.data as List<Movie>;
            return GridView.builder(
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
      ),
    );
  }
}