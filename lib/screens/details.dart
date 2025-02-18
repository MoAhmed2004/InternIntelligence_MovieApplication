import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/app_color.dart';
import 'package:movie_app/constant.dart';
import 'package:movie_app/model/movie.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
              leading: Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(
                  top: 16,
                  left: 16,
                ),
                decoration: BoxDecoration(
                  color: Colours.scaffoldBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
              ),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(

                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    "${Constant.imageUrl}${movie.backDropPath}",
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text(
                        "${movie.voteAverage.toString()}/10",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    movie.overview,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Release Date: ${movie.releaseDate}",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                      ),),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
