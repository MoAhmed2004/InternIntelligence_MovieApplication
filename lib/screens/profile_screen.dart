import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/firebase/fireStore_handler.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/favorite_manager.dart';
import 'package:movie_app/screens/details_screen.dart';
import 'package:movie_app/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  bool isEditing = false;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteManager>(context, listen: false).loadFavorites();
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('name_${user?.uid}');
    nameController.text = savedName ?? user?.displayName ?? '';

    final savedPath = prefs.getString('profile_image_${user?.uid}');
    if (savedPath != null && File(savedPath).existsSync()) {
      setState(() {
        profileImage = File(savedPath);
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/profile_${user?.uid}.png';
      final newImage = await File(picked.path).copy(newPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_${user?.uid}', newImage.path);

      setState(() {
        profileImage = newImage;
      });
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favManager = Provider.of<FavoriteManager>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.red),
        title: const Text('Profile', style: TextStyle(color: Colors.red)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Sign Out",
            onPressed: signOut,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/images/profile_placeholder.png')
                  as ImageProvider,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isEditing
                  ? SizedBox(
                width: 200,
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              )
                  : Text(
                "Name: ${nameController.text}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit,
                    color: Colors.red),
                onPressed: () async {
                  if (isEditing) {
                    final newName = nameController.text.trim();
                    if (newName.isNotEmpty && newName != user?.displayName) {
                      await user?.updateDisplayName(newName);
                      await FireStoreHandler.updateUserName(user!.uid, newName);

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('name_${user!.uid}', newName);
                    }
                    setState(() {
                      isEditing = false;
                    });
                  } else {
                    setState(() => isEditing = true);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Email address: ${user?.email ?? ''}",
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.red),
          const SizedBox(height: 16),
          const Text("Your Favorites",
              style: TextStyle(color: Colors.red, fontSize: 18)),
          const SizedBox(height: 12),
          if (favManager.favorites.isEmpty)
            const Text("No favorite movies yet.",
                style: TextStyle(color: Colors.white70))
          else
            Column(
              children: favManager.favorites.map((movie) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(
                    "https://image.tmdb.org/t/p/w92${movie.posterPath}",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text("Rating: ${movie.voteAverage}/10",
                      style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DetailsScreen(movie: movie),
                    ));
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
