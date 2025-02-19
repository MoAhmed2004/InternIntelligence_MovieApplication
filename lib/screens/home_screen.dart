import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details.dart';
import 'package:movie_app/screens/genre_movie_screen.dart';
import 'package:movie_app/screens/search.dart';
import 'package:movie_app/screens/top_rated_movies_screen.dart';
import 'package:movie_app/screens/upcoming_movies_screen.dart';
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
  late Future<List<Movie>> allMovies;
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];

  @override
  void initState() {
    super.initState();
    trendingMovies = api.getTrending();
    topRatedMovies = api.getTopRated();
    upComingMovies = api.getUpComing();
    allMovies = api.getAllMovies();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      api.searchMovies(_searchController.text).then((results) {
        setState(() {
          _searchResults = results;
        });
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Movie App',
              style: TextStyle(color: Colors.red, fontSize: 30)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Genres'),
              Tab(text: 'Search'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeTab(),
            _buildGenresTab(),
            _buildSearchTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
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
                    return Center(
                        child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final data = snapshot.data! as List<Movie>;
                    return TrendingSlider(snapshot: snapshot);
                  }
                },
              ),
            ),
            SizedBox(height: 35),
            Row(
              children: [
                Text("Top Rated Movies",
                    style: GoogleFonts.aBeeZee(fontSize: 25)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(TopRatedMoviesScreen.routeName);
                  },
                  child: Container(
                    child: Text("View All",
                        style: GoogleFonts.aBeeZee(fontSize: 14)),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red),
                  ),
                )
              ],
            ),
            SizedBox(height: 18),
            SizedBox(
              child: FutureBuilder(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error.toString()}'));
                  } else {
                    final data = snapshot.data as List<Movie>;
                    return MoviesSlider(snapshot: snapshot);
                  }
                },
              ),
            ),
            SizedBox(height: 35),
            Row(
              children: [
                Text("Upcoming Movies",
                    style: GoogleFonts.aBeeZee(fontSize: 25)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(UpComingMoviesScreen.routeName);
                  },
                  child: Container(
                    child: Text("View All",
                        style: GoogleFonts.aBeeZee(fontSize: 14)),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red),
                  ),
                )
              ],
            ),
            SizedBox(height: 18),
            SizedBox(
              child: FutureBuilder(
                future: upComingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error.toString()}'));
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

  Widget _buildGenresTab() {
    return FutureBuilder(
      future: allMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else {
          final movies = snapshot.data as List<Movie>;
          final genres =
              movies.expand((movie) => movie.genres).toSet().toList();
          return ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              final genreMovies = movies
                  .where((movie) => movie.genres.contains(genre))
                  .toList();
              return ListTile(
                title: Text(genre),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GenreMoviesScreen(genre: genre, movies: genreMovies),
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

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for movies...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultsScreen(query: query),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final movie = _searchResults[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text('Rating: ${movie.rating}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
