import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/GuestSessionResponse.dart';
import '../models/Movie.dart';
import '../models/MovieResponse.dart';

/// A service class that provides methods to interact with The Movie Database (TMDb) API.
class ApiService {
  // API key for accessing TMDb services
  static const String API_KEY = "7328c41084b110c6a401b3cabef41b40";

  // Base URL for the TMDb API
  static const String BASE_URL = "https://api.themoviedb.org/3";

  // API key query parameter for authentication
  static const String API_KEY_AUTH = 'api_key=$API_KEY';

  /// Fetches a new guest session from TMDb.
  ///
  /// This method creates a guest session that allows users to interact with
  /// the API without logging in, such as adding ratings.
  ///
  /// Returns a [GuestSessionResponse] if successful.
  /// Throws an [Exception] if there is an error or the request fails.
  Future<GuestSessionResponse> getGuestSession() async {
    const String url = '$BASE_URL/authentication/guest_session/new?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          return GuestSessionResponse.fromJson(responseData);
        } else {
          throw Exception(
              'Failed to create guest session: ${responseData['status_message']}');
        }
      } else {
        throw Exception(
            'Failed to get guest session. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting guest session: $error');
    }
  }

  /// Fetches the list of now-playing movies from TMDb.
  ///
  /// Returns a [List] of [Movie] objects representing the currently playing movies.
  /// Throws an [Exception] if there is an error or the request fails.
  Future<List<Movie>> getNowPlaying() async {
    const String url = '$BASE_URL/movie/now_playing?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['results'] != null) {
          return MovieResponse.fromJson(decodedData).results!;
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception(
            'Failed to get now playing. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting now playing: $error');
    }
  }

  /// Fetches the list of popular movies from TMDb.
  ///
  /// Returns a [List] of [Movie] objects representing the most popular movies.
  /// Throws an [Exception] if there is an error or the request fails.
  Future<List<Movie>> getPopular() async {
    const String url = '$BASE_URL/movie/popular?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(jsonDecode(response.body)).results!;
      } else {
        throw Exception(
            'Failed to get popular movies. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting popular movies: $error');
    }
  }

  /// Fetches the details of a specific movie from TMDb using its [movieId].
  ///
  /// Returns a [Movie] object containing detailed information about the movie.
  /// Throws an [Exception] if there is an error or the request fails.
  Future<Movie> getMovieDetail(int movieId) async {
    final String url = '$BASE_URL/movie/$movieId?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Movie.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get movie details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting movie details: $error');
    }
  }

  /// Fetches a list of movies similar to the given [movieId] from TMDb.
  ///
  /// This method filters out movies without a valid `posterPath`.
  ///
  /// Returns a [List] of [Movie] objects representing similar movies.
  /// Throws an [Exception] if there is an error or the request fails.
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final String url = '$BASE_URL/movie/$movieId/similar?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final movieResponse = MovieResponse.fromJson(result);
        final data = movieResponse.results;

        if (data != null) {
          // Filter out movies with null posterPath
          final filteredMovies =
              data.where((movie) => movie.posterPath != null).toList();

          return filteredMovies;
        } else {
          throw Exception('No similar movies found');
        }
      } else {
        throw Exception(
            'Failed to get similar movies. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting similar movies: $error');
    }
  }
}
