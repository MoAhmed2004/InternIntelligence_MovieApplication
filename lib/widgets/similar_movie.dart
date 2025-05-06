import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details_screen.dart';

class SimilarMovie extends StatefulWidget {
  const SimilarMovie({super.key, required this.movie});
  final Movie movie;

  @override
  State<SimilarMovie> createState() => _SimilarMovieState();
}

class _SimilarMovieState extends State<SimilarMovie> {
  late Future<List<Movie>> _similarMovies;
  final Api _api = Api();

  @override
  void initState() {
    super.initState();
    _similarMovies = _api.getSimilarMovies(widget.movie.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _similarMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Text("No similar movies found.");
        }
        final similar = snapshot.data!;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final movie = similar[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${Constant.imageUrl}${movie.posterPath}",
                          height: 160,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}