import 'package:flutter/material.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/details_screen.dart';
import 'package:movie_app/screens/search_result_screen.dart';
import 'package:movie_app/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchTab extends StatefulWidget {
  final Api api;

  const SearchTab({required this.api, Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _addToRecentSearches(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
    });
    await prefs.setStringList('recent_searches', recentSearches);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      widget.api.searchMovies(_searchController.text).then((results) {
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
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
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
                _addToRecentSearches(query);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(query: query),
                  ),
                );
              },
            ),
          ),

          if (recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Card(
                color: Colors.grey[900],
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recent Searches",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('recent_searches');
                              setState(() {
                                recentSearches.clear();
                              });
                            },
                            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: recentSearches.map((search) {
                          return InputChip(
                            label: Text(search, style: const TextStyle(color: Colors.black)),
                            backgroundColor: Colors.red,
                            avatar: const Icon(Icons.history, size: 18, color: Colors.black),
                            onPressed: () {
                              _searchController.text = search;
                              _addToRecentSearches(search);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultsScreen(query: search),
                                ),
                              );
                            },
                            onDeleted: () async {
                              setState(() => recentSearches.remove(search));
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setStringList('recent_searches', recentSearches);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),


          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  leading: Image.network(
                    "${Constant.imageUrl}${movie.posterPath}",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
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
      ),
    );
  }
}
