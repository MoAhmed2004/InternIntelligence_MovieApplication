class Movie {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  final List<String> genres;
  final double rating;
  final int? id;


  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
    required this.rating,
    this.id,
  });

  factory Movie.FromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? "Unknown Title",
      backDropPath: json["backdrop_path"] ?? "",
      originalTitle: json["original_title"] ?? "Unknown",
      overview: json["overview"] ?? "No overview available.",
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"] ?? "Unknown",
      voteAverage: (json["vote_average"] ?? 0.0)
          .toDouble(),
      genres: List<String>.from(json['genre_ids'].map((id) => genreMap[id])),
      rating: (json['vote_average'] ?? 0.0).toDouble(),
        id: json['id'],
    );
  }


  Map<String, dynamic> toJson() => {
    "title": title,
    "backdrop_path": backDropPath,
    "original_title": originalTitle,
    "overview": overview,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "vote_average": voteAverage,
  };
  static const Map<int, String> genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };


}

