class Movie {
  int id;
  double popularity;
  String title;
  String backdropPath;
  String posterPath;
  String overview;
  double voteAverage;

  bool adult;
  int voteCount;
  bool video;
  String originalLanguage;
  String originalTitle;
  DateTime releaseDate;

  Movie(
    this.id,
    this.popularity,
    this.title,
    this.backdropPath,
    this.posterPath,
    this.overview,
    this.voteAverage,
    this.voteCount,
    this.video,
    this.adult,
    this.originalLanguage,
    this.originalTitle,
    this.releaseDate,
  );

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"].toDouble(),
        voteCount = json["vote_count"],
        video = json["video"],
        posterPath = json["poster_path"],
        adult = json["adult"],
        backdropPath =
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        originalLanguage = json["original_language"],
        originalTitle = json["original_title"],
        title = json["title"],
        voteAverage = json["vote_average"].toDouble(),
        overview = json["overview"],
        releaseDate = DateTime.parse(json["release_date"]);
}
