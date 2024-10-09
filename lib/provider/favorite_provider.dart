import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/api/api_service.dart';
import '../data/models/Movie.dart';

class FavoriteProvider extends ChangeNotifier {
  ResultState? _favoriteState;
  List<Movie>? _favoriteMovies = [];
  String _favoriteMessage = '';

  List<Movie>? get favoriteMovies => _favoriteMovies;
  String get favoriteMessage => _favoriteMessage;
  ResultState? get favoriteState => _favoriteState;

  addMovieToFavorite(Movie movie) async {
    _favoriteState = ResultState.loading;
    notifyListeners();
    try {
      // Cek apakah movie sudah ada di watchlist
      bool isMovieInFavorite =
          _favoriteMovies!.any((item) => item.id == movie.id);
      if (isMovieInFavorite) {
        _favoriteMessage = "Sudah ada didalam favorite";
      } else {
        // Jika movie belum ada, tambahkan ke watchlist
        _favoriteMovies!.add(movie);
        _favoriteMessage = "Berhasil menambahkan item ke favorite";
        print("berhasil tambah favorite");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  bool? _isAddedToFavorite = false;
  bool? get isAddedToFavorite => _isAddedToFavorite;

  ResultState? _isFavState;
  ResultState? get isFavState => _isFavState;

  checkFavorite(int movieId) async {
    _isFavState = ResultState.loading;
    notifyListeners();
    try {
      // Cek apakah movie sudah ada di watchlist
      bool isMovieInFavorite =
          _favoriteMovies!.any((item) => item.id == movieId);

      if (isMovieInFavorite) {
        _favoriteMessage = "Sudah ada didalam favorite";
        _isAddedToFavorite = true;
      } else {
        // Jika movie belum ada, tambahkan ke watchlist
        _isAddedToFavorite = false;

        _favoriteMessage = "Berhasil menambahkan item ke favorite";
      }
    } catch (e) {
      _isFavState = ResultState.error;
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }


  // Fungsi untuk menghapus movie dari favorite
  removeMovieFromFavorite(Movie movie) async {
    _favoriteState = ResultState.loading;
    notifyListeners();
    try {
      _favoriteMovies!.removeWhere((item) => item.id == movie.id);
      _favoriteMessage = "Berhasil menghapus item dari favorite";
      _isAddedToFavorite = false;
      print("berhasil hapus favorite");
    } catch (e) {
      print(e.toString());
    } finally {
      _favoriteState = ResultState.success;
      notifyListeners();
    }
  }
}
