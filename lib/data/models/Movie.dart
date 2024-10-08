class Movie {
  int? id;
  String? title;
  String? originalTitle;
  String? backdropPath;
  String? posterPath;
  String? overview;
  double? popularity;
  String? releaseDate;
  double? voteAverage;
  int? voteCount;
  bool? adult;
  bool? video;
  List<int>? genreIds;

  Movie({
    this.id,
    this.title,
    this.originalTitle,
    this.backdropPath,
    this.posterPath,
    this.overview,
    this.popularity,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.adult,
    this.video,
    this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      originalTitle: json['original_title'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      popularity: json['popularity'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      adult: json['adult'],
      video: json['video'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'].map((x) => x))
          : null,
    );
  }
}

enum OriginalLanguage { EN, KO, PT }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "ko": OriginalLanguage.KO,
  "pt": OriginalLanguage.PT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
