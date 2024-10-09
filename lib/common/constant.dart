import 'package:flutter/material.dart';

/// Main green color used throughout the application
const Color cGreen = Color(0xFF0FA226);

/// Green color with 10% transparency, commonly used as a background
const Color cGreen05 = Color.fromRGBO(15, 162, 38, .1);

/// Black color used for background and other elements
const Color cBlack = Color(0xFF0C1117);

/// Base URL for fetching images from the TMDB API
const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

/// Primary color scheme used in the app theme
const kColorScheme = ColorScheme(
  primary: cGreen,
  primaryContainer: cGreen,
  secondary: Colors.blue,
  secondaryContainer: Colors.blue,
  surface: cBlack,
  background: cBlack,
  error: Colors.red,
  onPrimary: cBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
