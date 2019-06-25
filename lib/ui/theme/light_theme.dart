import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    primarySwatch: Colors.lightBlue,
    textTheme: TextTheme(
      body1: TextStyle(color: Colors.white),
    ),
    brightness: Brightness.dark,
  );
}
