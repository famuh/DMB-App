import 'package:dmb_app/common/state_enum.dart';
import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/models/GuestSessionResponse.dart';

/// A provider class that manages the guest session for the application.
class GuestSessionProvider with ChangeNotifier {
  /// A getter that returns the current guest session information.
  GuestSessionResponse? _guestSession;
  GuestSessionResponse? get guestSession => _guestSession;

  /// A getter that returns the current authentication status
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  /// A getter that returns the current authentication error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// A getter that returns the authentication state
  ResultState? _state;
  ResultState? get state => _state;

  /// A getter that returns the guest session ID
  String? get sessionId => _sessionId;
  String? _sessionId;

  /// An instance of ApiService to perform API operations.
  final ApiService _apiService = ApiService();

  /// Creates a guest session by calling the API service.
  ///
  /// This method sets the state to loading, attempts to create a guest session,
  /// and updates the authentication status accordingly. In case of an error,
  /// it sets the error message and state to error.
  Future<void> createGuestSession() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      _guestSession = await _apiService.getGuestSession();
      _isAuthenticated = true;
      _errorMessage = null;
      _state = ResultState.success;
      _sessionId = _guestSession?.guestSessionId;
    } catch (error) {
      _isAuthenticated = false;
      _guestSession = null;
      _errorMessage = error.toString();
      _state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }

  /// Logs out the current guest session.
  ///
  /// This method resets the guest session information and the authentication
  /// status, notifying listeners of the changes.
  void logout() {
    _guestSession = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }
}
