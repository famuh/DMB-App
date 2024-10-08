import 'dart:convert';

import 'package:dmb_app/data/models/MovieResponse.dart';
import 'package:http/http.dart' as http;

import '../models/GuestSessionResponse.dart';
import '../models/Movie.dart';

class ApiService {
  static const API_KEY = "7328c41084b110c6a401b3cabef41b40";
  static const BASE_URL = "https://api.themoviedb.org/3";
  static const API_KEY_AUTH = 'api_key=$API_KEY';

// guest session
  Future<GuestSessionResponse> getGuestSession() async {
    const url = '$BASE_URL/authentication/guest_session/new?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response is successful
        if (responseData['success'] == true) {
          print("sukses : ${responseData['guest_session_id']}");
          return GuestSessionResponse.fromJson(responseData);
        } else {
          print("sukses : ${responseData['status_message']}");
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

  // now playing
  Future<List<Movie>> getNowPlaying() async {
    const url = '$BASE_URL/movie/now_playing?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['results'] != null) {
          return MovieResponse.fromJson(jsonDecode(response.body)).results!;
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

  Future<List<Movie>> getPopular() async {
    const url = '$BASE_URL/movie/popular?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(jsonDecode(response.body)).results!;
      } else {
        throw Exception(
            'Failed to get popular. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting popular: $error');
    }
  }

  Future<Movie> getMovieDetail(int movieId) async {
    String url = '$BASE_URL/movie/$movieId?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Movie.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get popular. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting popular: $error');
    }
  }

  Future<List<Movie>> getSimiliarMovies(int movieId) async {
    String url = '$BASE_URL/movie/$movieId/similar?$API_KEY_AUTH';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(jsonDecode(response.body)).results!;
      } else {
        throw Exception(
            'Failed to get similiar. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting similiar: $error');
    }
  }

}
