import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/app_color.dart';
import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/favorite_manager.dart';
import 'package:movie_app/widgets/cast.dart';
import 'package:movie_app/widgets/similar_movie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<String?> _trailerUrl;
  final Api _api = Api();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _trailerUrl = _api.getTrailerUrl(widget.movie.id ?? 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isFav = Provider.of<FavoriteManager>(context, listen: false)
            .isFavorite(widget.movie);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black,
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
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                  final favManager = Provider.of<FavoriteManager>(context, listen: false);

                  setState(() {
                    if (isFav) {
                      favManager.removeFavorite(widget.movie);
                      isFav = false;
                    } else {
                      favManager.addFavorite(widget.movie);
                      isFav = true;
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav ? 'Added to Favorites' : 'Removed from Favorites',
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: widget.movie.backDropPath != null
                    ? Image.network(
                  "${Constant.imageUrl}${widget.movie.backDropPath}",
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.movie,
                        size: 100,
                        color: Colors.white70,
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey.shade800,
                  child: const Icon(
                    Icons.movie,
                    size: 100,
                    color: Colors.white70,
                  ),
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
                  if (widget.movie.releaseDate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Release Date: ${widget.movie.releaseDate}",
                            style: GoogleFonts.roboto(
                                fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  if (widget.movie.genres.isNotEmpty)
                    Text("Genres: ${widget.movie.genres.join(', ')}",
                        style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(widget.movie.overview,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 18, color: Colors.white70)),
                  const SizedBox(height: 24),
                  Text("Cast",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 16),
                  CastList(movie: widget.movie),
                  const SizedBox(height: 30),
                  Text("Similar Movies",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 16),
                  SimilarMovie(movie: widget.movie),

                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: _trailerUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            final uri = Uri.parse(snapshot.data!);
            return FloatingActionButton.extended(
              onPressed: () async {
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
