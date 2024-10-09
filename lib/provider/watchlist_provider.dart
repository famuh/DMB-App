import 'package:flutter/material.dart';

import '../common/state_enum.dart';
import '../data/models/Movie.dart';

/// A provider class that manages the watchlist movies state for the application.
///
/// This class uses the ChangeNotifier to notify listeners when the watchlist
/// movies list changes, such as when movies are added or removed from the watchlist.
class WatchlistProvider extends ChangeNotifier {
  // A getter that returns the favorite state
  ResultState? _watchlistState;
  ResultState? get watchlistState => _watchlistState;

  // A getter that returns [List] of favorite movies
  List<Movie>? _watchlistMovies = [];
  List<Movie>? get watchlistMovies => _watchlistMovies;

  // A getter that returns the message
  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  /// Adds a movie to the watchlist list.
  /// The [movie] parameter is the movie to be added.
  addMovieToWatchList(Movie movie) async {
    _watchlistState = ResultState.loading;
    notifyListeners();
    try {
      // Check if the movie is already in watchlist
      bool isMovieInWatchlist =
          _watchlistMovies!.any((item) => item.id == movie.id);
      if (isMovieInWatchlist) {
        _watchlistMessage = "Already in the watchlist";
      } else {
        // If the movie is not present, add it to watchlist
        _watchlistMovies!.add(movie);
        _watchlistMessage = "Successfully added an item to watchlist";
      }
    } catch (e) {
      // Handle any exceptions that occur
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// A getter that returns whether the movie has been added to watchlist.
  bool? _isAddedToWatchlist = false;
  bool? get isAddedToWatchlist => _isAddedToWatchlist;

  /// A getter that returns the current state of checking watchlist.
  ResultState? _isWLState;
  ResultState? get isWLState => _isWLState;

  /// Checks if a movie is in the watchlist list by its ID.
  checkWatchlist(int movieId) async {
    _isWLState = ResultState.loading;
    notifyListeners();
    try {
      // Check if the movie is in watchlist
      bool isMovieInWatchlist =
          _watchlistMovies!.any((item) => item.id == movieId);

      if (isMovieInWatchlist) {
        _watchlistMessage = "Already in the watchlist";
        _isAddedToWatchlist = true;
      } else {
        // If the movie is not present, indicate it is not added to watchlist
        _isAddedToWatchlist = false;
        _watchlistMessage = "Not in the favorite";
      }
    } catch (e) {
      _isWLState = ResultState.error;
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Removes a movie from the watchlist list.
  removeMovieFromWatchlist(Movie movie) async {
    _watchlistState = ResultState.loading;
    notifyListeners();
    try {
      // Remove the movie from watchlist
      _watchlistMovies!.removeWhere((item) => item.id == movie.id);
      _watchlistMessage = "Successfully remove an item from watchlist";
      _isAddedToWatchlist = false;
    } catch (e) {
      // Handle any exceptions that occur
      debugPrint(e.toString());
    } finally {
      _watchlistState = ResultState.success;
      notifyListeners();
    }
  }
}
