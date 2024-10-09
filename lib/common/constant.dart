import 'package:flutter/material.dart';

const Color cGreen = Color(0xFF0FA226);
const Color cGreen05 = Color.fromRGBO(15, 162, 38, .1);
const Color cBlack = Color(0xFF0C1117);

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';


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
