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

  List<Movie> _similiarMovies = [];
  List<Movie> get similiarMovies => _similiarMovies;

  ResultState? _similiarState;
  ResultState? get similiarState => _similiarState;

  Future<void> fetchDetailMovie(int movieId) async {
    _detailState = ResultState.loading;
    _similiarState = ResultState.loading;

    notifyListeners();
    try {
      final detailResult = await _apiService.getMovieDetail(movieId);
      final similiarResult = await _apiService.getSimiliarMovies(movieId);

      if (detailResult != null && similiarResult.isNotEmpty) {
        _detailState = ResultState.success;
        _similiarState = ResultState.success;
        _detailMovie = detailResult;

        List<Movie> limitedSimiliarMovies = similiarResult.length > 6
            ? similiarResult.sublist(0, 20)
            : similiarResult;

        _similiarMovies = limitedSimiliarMovies;
      } else if (detailResult == null && similiarResult.isEmpty) {
        _detailState = ResultState.noData;
        _similiarState = ResultState.noData;
        _detailMovie = null;
        _similiarMovies = [];
      } else {
        _detailState = ResultState.error;
        _similiarState = ResultState.error;
        _errorDetail = 'Gagal memuat data';
      }
    } catch (e) {
      _detailState = ResultState.error;
      _similiarState = ResultState.error;
      _errorDetail = e.toString();
    } finally {
      notifyListeners();
    }
  }


   ResultState? _checkState;
  bool? _isAdd;
  String _isAddError = '';

  bool? get isAdd => _isAdd;
  String get isAddError => _isAddError;
  ResultState? get checkState => _checkState;

  Future<void> checkWatchlist(String sessionId, int movieId) async {
    _checkState = ResultState.loading;
    notifyListeners();
    try {
      await _apiService.isMovieInWatchlist(movieId, sessionId);
      _checkState = ResultState.success;
      _isAdd = true;
    } catch (e) {
      _checkState = ResultState.error;
      _isAddError = e.toString();
      _isAdd = false;
    } finally {
      notifyListeners();
    }
  }
}
