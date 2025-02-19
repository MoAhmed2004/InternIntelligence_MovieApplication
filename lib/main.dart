
import 'package:flutter/material.dart';
import 'package:movie_app/screens/details.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/top_rated_movies_screen.dart';
import 'package:movie_app/screens/upcoming_movies_screen.dart';

import 'app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colours.scaffoldBgColor,
      ),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        TopRatedMoviesScreen.routeName: (context) => const TopRatedMoviesScreen(),
        UpComingMoviesScreen.routeName: (context) => const UpComingMoviesScreen(),
      },

      initialRoute: HomeScreen.routeName,
    );
  }
}