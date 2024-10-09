import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

class WatchlistProvider extends ChangeNotifier {
  ResultState? _watchlistState;
  List<Movie>? _watchlistMovies = [];
  String _watchlistMessage = '';

  List<Movie>? get watchlistMovies => _watchlistMovies;
  String get watchlistMessage => _watchlistMessage;
  ResultState? get watchlistState => _watchlistState;

  addMovieToWatchList(Movie movie) async {
    _watchlistState = ResultState.loading;
    notifyListeners();
    try {
      // Cek apakah movie sudah ada di watchlist
      bool isMovieInWatchlist =
          _watchlistMovies!.any((item) => item.id == movie.id);
      if (isMovieInWatchlist) {
        _watchlistMessage = "Sudah ada didalam watchlist";
      } else {
        // Jika movie belum ada, tambahkan ke watchlist
        _watchlistMovies!.add(movie);
        _watchlistMessage = "Berhasil menambahkan item ke watchlist";
        print("berhasil tambah watchlist");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  bool? _isAddedToWatchlist = false;
  bool? get isAddedToWatchlist => _isAddedToWatchlist;

  ResultState? _isWLState;
  ResultState? get isWLState => _isWLState;

  checkWatchlist(int movieId) async {
    _isWLState = ResultState.loading;
    notifyListeners();
    try {
      // Cek apakah movie sudah ada di watchlist
      bool isMovieInWatchlist =
          _watchlistMovies!.any((item) => item.id == movieId);

      if (isMovieInWatchlist) {
        _watchlistMessage = "Sudah ada didalam watchlist";
        _isAddedToWatchlist = true;
      } else {
        // Jika movie belum ada, tambahkan ke watchlist
        _isAddedToWatchlist = false;

        _watchlistMessage = "Berhasil menambahkan item ke watchlist";
      }
    } catch (e) {
      _isWLState = ResultState.error;
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

   // Fungsi untuk menghapus movie dari favorite
  removeMovieFromWatchlist(Movie movie) async {
    _watchlistState = ResultState.loading;
    notifyListeners();
    try {
      _watchlistMovies!.removeWhere((item) => item.id == movie.id);
      _watchlistMessage = "Berhasil menghapus item dari watchlist";
      print("berhasil hapus watchlis");
    } catch (e) {
      print(e.toString());
    } finally {
      _watchlistState = ResultState.success;
      notifyListeners();
    }
  }
}
