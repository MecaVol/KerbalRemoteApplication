import 'package:flutter/material.dart';

class ThemeGenerator {
  static ThemeData getDefaultTheme() {
    return ThemeData(
      primarySwatch: Colors.orange,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Text stuff
      // todo

      // TextField stuff:
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      )
    );
  }
}