import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

/// A provider class that manages the fetching of movie lists, including now playing and popular movies.
class MovieListProvider extends ChangeNotifier {
  // Instance of API Service
  final ApiService _apiService = ApiService();

  // State and data for now playing movies
  ResultState? _nowPlayingState;
  ResultState? get nowPlayingState => _nowPlayingState;

  /// A getter that returns the list of now playing movies.
  List<Movie>? _nowPlayingMovies;
  List<Movie>? get nowPlayingMovies => _nowPlayingMovies;

  /// A getter that returns the error message for now playing movies.
  String _npErrorMessage = '';
  String get errorMessage => _npErrorMessage;

  /// Fetches the list of now playing movies from the API.
  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = ResultState.loading;
    notifyListeners();
    try {
      final result = await _apiService.getNowPlaying();

      if (result.isNotEmpty) {
        _nowPlayingState = ResultState.success;

        // Limit the number of now playing movies to a maximum of 6
        List<Movie> limitedMovies =
            result.length > 6 ? result.sublist(0, 6) : result;
        _nowPlayingMovies = limitedMovies;
      } else {
        _nowPlayingState = ResultState.noData;
        _nowPlayingMovies = [];
      }
    } catch (e) {
      _nowPlayingState = ResultState.error;
      _npErrorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // State and data for popular movies
  ResultState? _popularState;
  ResultState? get popularState => _popularState;

  /// A getter that returns the list of popular movies.
  List<Movie>? _popularMovies;
  List<Movie>? get popularMovies => _popularMovies;

  /// A getter that returns the error message for popular movies.
  String _popularError = '';
  String get popularError => _popularError;

  /// Fetches the list of popular movies from the API.
  Future<void> fetchPopularMovies() async {
    _popularState = ResultState.loading;
    notifyListeners();
    try {
      final result = await _apiService.getPopular();

      if (result.isNotEmpty) {
        _popularState = ResultState.success;

        // Limit the number of popular movies to a maximum of 20
        List<Movie> limitedMovies =
            result.length > 20 ? result.sublist(0, 20) : result;
        _popularMovies = limitedMovies;
      } else {
        _popularState = ResultState.noData;
        _popularMovies = [];
      }
    } catch (e) {
      _popularState = ResultState.error;
      _popularError = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
