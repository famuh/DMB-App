// ignore_for_file: file_names, dangling_library_doc_comments

/// A class representing a movie.
/// This class contains details about a movie, including its ID,
/// title, release information, and various attributes related to
/// its popularity and viewer ratings.
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

  /// Factory method to create a [Movie] instance from a JSON response.
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

  /// Converts the [Movie] instance to a JSON-compatible [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'overview': overview,
      'popularity': popularity,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'video': video,
      'genre_ids': genreIds,
    };
  }
}

/// An enumeration representing the original languages of movies.
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
