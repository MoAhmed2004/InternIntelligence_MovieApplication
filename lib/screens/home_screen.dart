import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/search.dart';
import 'package:movie_app/widgets/movies_slider.dart';
import 'package:movie_app/widgets/trending_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Api api = Api();
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upComingMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = api.getTrending();
    topRatedMovies = api.getTopRated();
    upComingMovies = api.getUpComing();
  }

  void _searchMovies(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Movie App', style: TextStyle(color: Colors.red, fontSize: 30)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _searchMovies,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              Text("Trending Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
              SizedBox(height: 18),
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
              SizedBox(height: 35),
              Text("Top Rated Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
              SizedBox(height: 18),
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
              SizedBox(height: 35),
              Text("Upcoming Movies", style: GoogleFonts.aBeeZee(fontSize: 25)),
              SizedBox(height: 18),
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
      ),
    );
  }
}