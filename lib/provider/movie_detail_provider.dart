import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

/// A provider class that manages the details of a movie and its similar movies.
///
/// This class uses ChangeNotifier to notify listeners of changes to the movie
/// details or similar movies, including loading states and error messages.
class MovieDetailProvider extends ChangeNotifier {
  // Instance of API Service
  final ApiService _apiService = ApiService();

  /// A getter that returns the current state of movie detail fetching.
  ResultState? _detailState;
  ResultState? get detailState => _detailState;

  /// A getter that returns the detailed movie information.
  Movie? _detailMovie;
  Movie? get detailMovie => _detailMovie;

  /// A getter that returns the error message for movie detail fetching.
  String _errorDetail = '';
  String get errorMessage => _errorDetail;

  /// A getter that returns the list of similar movies.
  List<Movie> _similarMovies = [];
  List<Movie> get similarMovies => _similarMovies;

  /// A getter that returns the current state of similar movie fetching.
  ResultState? _similarState;
  ResultState? get similarState => _similarState;

  /// Fetches the details of a movie and its similar movies based on the movie ID.
  Future<void> fetchDetailMovie(int movieId) async {
    _detailState = ResultState.loading;
    _similarState = ResultState.loading;

    notifyListeners();
    try {
      final detailResult = await _apiService.getMovieDetail(movieId);
      final similarResult = await _apiService.getSimilarMovies(movieId);

      if (detailResult != null && similarResult.isNotEmpty) {
        _detailState = ResultState.success;
        _similarState = ResultState.success;
        _detailMovie = detailResult;

        // Limit similar movies to a maximum of 20
        List<Movie> limitedSimiliarMovies = similarResult.length > 20
            ? similarResult.sublist(0, 20)
            : similarResult;

        _similarMovies = limitedSimiliarMovies;
      } else if (detailResult == null && similarResult.isEmpty) {
        _detailState = ResultState.noData;
        _similarState = ResultState.noData;
        _detailMovie = null;
        _similarMovies = [];
      } else {
        _detailState = ResultState.error;
        _similarState = ResultState.error;
        _errorDetail = 'Failed to load data';
      }
    } catch (e) {
      _detailState = ResultState.error;
      _similarState = ResultState.error;
      _errorDetail = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
