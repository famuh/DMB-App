import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

class MovieDetailProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ResultState? _detailState;
  Movie? _detailMovie;
  String _errorDetail = '';

  Movie? get detailMovie => _detailMovie;
  String get errorMessage => _errorDetail;
  ResultState? get detailState => _detailState;

  List<Movie> _similarMovies = [];
  List<Movie> get similarMovies => _similarMovies;

  ResultState? _similarState;
  ResultState? get similarState => _similarState;

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

        List<Movie> limitedSimiliarMovies = similarResult.length > 6
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
        _errorDetail = 'Gagal memuat data';
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
