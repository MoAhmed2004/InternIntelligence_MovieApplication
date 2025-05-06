import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/login/login_screen.dart';
import 'package:movie_app/screens/top_rated_movies_screen.dart';
import 'package:movie_app/screens/upcoming_movies_screen.dart';
import 'package:movie_app/signup/register_screen.dart';
import 'package:movie_app/screens/profile_screen.dart';
import 'package:movie_app/tabs/home_tab.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/favorite_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        HomeTab.routeName: (_) => HomeScreenTab(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        TopRatedMoviesScreen.routeName: (_) => const TopRatedMoviesScreen(),
        UpComingMoviesScreen.routeName: (_) => const UpComingMoviesScreen(),
      },
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData) {
          // ✅ Load user-specific favorites
          Provider.of<FavoriteManager>(context, listen: false).loadFavorites();
          return HomeScreenTab();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
