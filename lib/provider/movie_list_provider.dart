import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

class MovieListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ResultState? _nowPlayingState;
  List<Movie>? _nowPlayingMovies;
  String _npErrorMessage = '';

  List<Movie>? get nowPlayingMovies => _nowPlayingMovies;
  String get errorMessage => _npErrorMessage;
  ResultState? get nowPlayingState => _nowPlayingState;

  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = ResultState.loading;
    notifyListeners();
    try {
      final result = await _apiService.getNowPlaying();

      if (result.isNotEmpty) {
        _nowPlayingState = ResultState.success;
        List<Movie> limitedMovies =
            result.length > 6 ? result.sublist(0, 6) : result;

        _nowPlayingMovies = limitedMovies;
      } else {
        _nowPlayingState = ResultState.noData;
        _nowPlayingMovies = result;
      }
    } catch (e) {
      _nowPlayingState = ResultState.error;
      _npErrorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  ResultState? _popularState;
  List<Movie>? _popularMovies;
  String _popularError = '';

  List<Movie>? get popularMovies => _popularMovies;
  String get popularError => _popularError;
  ResultState? get popularState => _popularState;

  Future<void> fetchPopularMovies() async {
    _popularState = ResultState.loading;
    notifyListeners();
    try {
      final result = await _apiService.getPopular();

      if (result.isNotEmpty) {
        _popularState = ResultState.success;
        List<Movie> limitedMovies =
            result.length > 20 ? result.sublist(0, 20) : result;

        _popularMovies = limitedMovies;
      } else {
        _popularState = ResultState.noData;
        _popularMovies = [];
      }
    } catch (e) {
      print('Error fetching popular movies: $e'); // Tambahkan log untuk debug

      _popularState = ResultState.error;
      _popularError = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
