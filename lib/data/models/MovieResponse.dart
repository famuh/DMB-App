

import 'dart:convert';

import 'package:dmb_app/data/models/Movie.dart';

MovieResponse movieResponseFromJson(String str) => MovieResponse.fromJson(json.decode(str));


class MovieResponse {
  int? page;
  List<Movie>? results;
  int? totalPages;
  int? totalResults;

  MovieResponse({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'],
      results: json['results'] != null
          ? List<Movie>.from(json['results'].map((x) => Movie.fromJson(x)))
          : null,
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class Dates {
    DateTime maximum;
    DateTime minimum;

    Dates({
        required this.maximum,
        required this.minimum,
    });

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

    Map<String, dynamic> toJson() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
}





