import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/top_rated_movies_screen.dart';
import 'package:movie_app/screens/upcoming_movies_screen.dart';
import 'package:movie_app/widgets/movies_slider.dart';
import 'package:movie_app/widgets/trending_slider.dart';

class HomeTab extends StatelessWidget {
  final Future<List<Movie>> trendingMovies;
  final Future<List<Movie>> topRatedMovies;
  final Future<List<Movie>> upComingMovies;

  static const String routeName = '/home';

  const HomeTab({
    required this.trendingMovies,
    required this.topRatedMovies,
    required this.upComingMovies,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Text("Trending Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
            const SizedBox(height: 18),
            SizedBox(
              child: FutureBuilder(
                future: trendingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final data = snapshot.data as List<Movie>;
                    return TrendingSlider(snapshot: snapshot);
                  }
                },
              ),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                Text("Top Rated Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(TopRatedMoviesScreen.routeName);
                  },
                  child: Container(
                    child: Text("View All", style: GoogleFonts.aBeeZee(fontSize: 14)),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: Colors.red),
                  ),
                )
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              child: FutureBuilder(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final data = snapshot.data as List<Movie>;
                    return MoviesSlider(snapshot: snapshot);
                  }
                },
              ),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                Text("Upcoming Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(UpComingMoviesScreen.routeName);
                  },
                  child: Container(
                    child: Text("View All", style: GoogleFonts.aBeeZee(fontSize: 14)),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: Colors.red),
                  ),
                )
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              child: FutureBuilder(
                future: upComingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final data = snapshot.data as List<Movie>;
                    return MoviesSlider(snapshot: snapshot);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}