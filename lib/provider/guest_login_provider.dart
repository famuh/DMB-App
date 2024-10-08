import 'package:dmb_app/common/state_enum.dart';
import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/models/GuestSessionResponse.dart';

class GuestSessionProvider with ChangeNotifier {
  GuestSessionResponse? _guestSession;
  bool _isAuthenticated = false;
  String? _errorMessage;
  ResultState? _state;

  GuestSessionResponse? get guestSession => _guestSession;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  ResultState? get state => _state;

  String? get sessionId => _sessionId;
  String? _sessionId;


  final ApiService _apiService = ApiService();

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

  void logout() {
    _guestSession = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }
}
