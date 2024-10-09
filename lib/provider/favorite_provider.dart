import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/models/Movie.dart';

/// A provider class that manages the favorite movies state for the application.
///
/// This class uses the ChangeNotifier to notify listeners when the favorite
/// movies list changes, such as when movies are added or removed from the favorites.
class FavoriteProvider extends ChangeNotifier {
  // A getter that returns the favorite state
  ResultState? _favoriteState;
  ResultState? get favoriteState => _favoriteState;

  // A getter that returns [List] of favorite movies
  List<Movie>? get favoriteMovies => _favoriteMovies;
  List<Movie>? _favoriteMovies = [];

  // A getter that returns the message
  String _favoriteMessage = '';
  String get favoriteMessage => _favoriteMessage;

  /// Adds a movie to the favorites list.
  /// The [movie] parameter is the movie to be added.
  addMovieToFavorite(Movie movie) async {
    _favoriteState = ResultState.loading;
    notifyListeners();
    try {
      // Check if the movie is already in favorites
      bool isMovieInFavorite =
          _favoriteMovies!.any((item) => item.id == movie.id);
      if (isMovieInFavorite) {
        _favoriteMessage = "Already in the favorite";
      } else {
        // If the movie is not present, add it to favorites
        _favoriteMovies!.add(movie);
        _favoriteMessage = "Successfully added an item to favorites";
      }
    } catch (e) {
      // Handle any exceptions that occur
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// A getter that returns whether the movie has been added to favorites.
  bool? _isAddedToFavorite = false;
  bool? get isAddedToFavorite => _isAddedToFavorite;

  /// A getter that returns the current state of checking favorites.
  ResultState? _isFavState;
  ResultState? get isFavState => _isFavState;

  /// Checks if a movie is in the favorites list by its ID.
  checkFavorite(int movieId) async {
    _isFavState = ResultState.loading;
    notifyListeners();
    try {
      // Check if the movie is in favorites
      bool isMovieInFavorite =
          _favoriteMovies!.any((item) => item.id == movieId);

      if (isMovieInFavorite) {
        _favoriteMessage = "Already in the favorite";
        _isAddedToFavorite = true;
      } else {
        // If the movie is not present, indicate it is not added to favorites
        _isAddedToFavorite = false;
        _favoriteMessage = "Not in the favorite";
      }
    } catch (e) {
      _isFavState = ResultState.error;
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Removes a movie from the favorites list.
  removeMovieFromFavorite(Movie movie) async {
    _favoriteState = ResultState.loading;
    notifyListeners();
    try {
      // Remove the movie from favorites
      _favoriteMovies!.removeWhere((item) => item.id == movie.id);
      _favoriteMessage = "Successfully remove an item from favorites";
      _isAddedToFavorite = false;
    } catch (e) {
      // Handle any exceptions that occur
      debugPrint(e.toString());
    } finally {
      _favoriteState = ResultState.success;
      notifyListeners();
    }
  }
}
