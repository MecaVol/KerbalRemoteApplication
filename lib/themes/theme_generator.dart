import 'package:flutter/material.dart';

class ThemeGenerator {
  static ThemeData getDefaultTheme() {
    return ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}