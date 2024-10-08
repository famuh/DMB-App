import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

class WatchlistProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ResultState? _watchlistState;
  List<Movie>? _watchlist;
  String _errorMessage = '';

  List<Movie>? get watchlist => _watchlist;
  String get errorMessage => _errorMessage;
  ResultState? get watchlistState => _watchlistState;

  Future<void> addWatchlist(String sessionId, Movie movie) async {
    _watchlistState = ResultState.loading;
    notifyListeners();
    try {
      await _apiService.addWatchlist(sessionId, movie.id!);

      _watchlistState = ResultState.success;
      _watchlist?.add(movie);
    } catch (e) {
      _watchlistState = ResultState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

 
}
