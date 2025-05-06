import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/profile_screen.dart';
import 'package:movie_app/tabs/genre_tab.dart';
import 'package:movie_app/tabs/home_tab.dart';
import 'package:movie_app/tabs/search_tab.dart';

class HomeScreenTab extends StatefulWidget {
  static const String routeName = 'home_screen';
  const HomeScreenTab({Key? key}) : super(key: key);

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  final Api api = Api();
  int _selectedIndex = 0;

  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upComingMovies;
  late Future<List<Movie>> allMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = api.getTrending();
    topRatedMovies = api.getTopRated();
    upComingMovies = api.getUpComing();
    allMovies = api.getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(
        trendingMovies: trendingMovies,
        topRatedMovies: topRatedMovies,
        upComingMovies: upComingMovies,
      ),
      GenresTab(allMovies: allMovies),
      SearchTab(api: api),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'MovieNest',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Genres'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
