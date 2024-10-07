import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/models/GuestSessionResponse.dart';

class GuestSessionProvider with ChangeNotifier {
  GuestSessionResponse? _guestSession;
  bool _isAuthenticated = false;
  String? _errorMessage;

  GuestSessionResponse? get guestSession => _guestSession;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> createGuestSession() async {
    try {
      _guestSession = await _apiService.getGuestSession();
      _isAuthenticated = true;
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _isAuthenticated = false;
      _guestSession = null;
      _errorMessage = error.toString();
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
