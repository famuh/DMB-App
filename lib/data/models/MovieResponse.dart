// To parse this JSON data, do
//
//     final movieResponse = movieResponseFromJson(jsonString);

import 'dart:convert';

import 'package:dmb_app/data/models/Movie.dart';

MovieResponse movieResponseFromJson(String str) => MovieResponse.fromJson(json.decode(str));

String movieResponseToJson(MovieResponse data) => json.encode(data.toJson());

class MovieResponse {
    Dates dates;
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    MovieResponse({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        dates: Dates.fromJson(json["dates"]),
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "dates": dates.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
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





