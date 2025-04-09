import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/app_color.dart';
import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/screens/favorite_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<List<Map<String, String>>> _cast;
  late Future<String?> _trailerUrl;
  late Future<List<Movie>> _similarMovies;
  final Api _api = Api();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _cast = _api.getCast(widget.movie.id??0);
    _trailerUrl = _api.getTrailerUrl(widget.movie.id??0);
    _similarMovies = _api.getSimilarMovies(widget.movie.id??0);
    isFav = FavoriteManager.isFavorite(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(top: 16, left: 16),
              decoration: BoxDecoration(
                color: Colours.scaffoldBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            expandedHeight: 300,
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    FavoriteManager.toggleFavorite(widget.movie);
                    isFav = !isFav;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isFav
                        ? 'Added to Favorites'
                        : 'Removed from Favorites'),
                  ));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  "${Constant.imageUrl}${widget.movie.backDropPath}",
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      Text(
                        "${widget.movie.voteAverage.toString()}/10",
                        style: GoogleFonts.aBeeZee(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Genres: (${widget.movie.genres.join(', ')})"),
                  const SizedBox(height: 20),
                  Text(widget.movie.overview,
                      style: GoogleFonts.aBeeZee(fontSize: 18)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Release Date: ${widget.movie.releaseDate}",
                        style: GoogleFonts.roboto(fontSize: 18)),
                  ),

                  const SizedBox(height: 24),
                  Text("Cast",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Map<String, String>>>(
                    future: _cast,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text("Error loading cast: ${snapshot.error}");
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No cast information available");
                      }

                      final cast = snapshot.data!;
                      return SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cast.length,
                          itemBuilder: (context, index) {
                            final actor = cast[index];
                            return Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      actor['photo']!,
                                      height: 150,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 150,
                                          width: 120,
                                          color: Colors.grey.shade800,
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white70,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    actor['name']!,
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    actor['character']!,
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  Text("Similar Movies",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Movie>>(
                    future: _similarMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(movie: movie),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<String?> (
        future: _trailerUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
            return FloatingActionButton.extended(
              onPressed: () async {
                final url = snapshot.data!;
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch trailer')),
                  );
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Watch Trailer"),
              backgroundColor: Colors.redAccent,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}