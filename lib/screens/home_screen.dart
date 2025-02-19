import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/tabs/genre_tab.dart';
import 'package:movie_app/tabs/homeScreen_tab.dart';

import 'package:movie_app/tabs/search_tab.dart';

class HomeScreenTab extends StatefulWidget {

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  final Api api = Api();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Movie App', style: TextStyle(color: Colors.red, fontSize: 30)),
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
            HomeTab(
              trendingMovies: trendingMovies,
              topRatedMovies: topRatedMovies,
              upComingMovies: upComingMovies,
            ),
            GenresTab(allMovies: allMovies),
            SearchTab(api: api),
          ],
        ),
      ),
    );
  }
}