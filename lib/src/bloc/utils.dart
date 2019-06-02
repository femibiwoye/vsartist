import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    accentColor: UiData.orange,
    canvasColor: Colors.transparent,
    iconTheme: new IconThemeData(color: Colors.black),
    primaryIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Color(0xFF1a1a1a),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 22),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14),
    ),
  );
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Colors.black,
    accentColor: UiData.orange,
    canvasColor: Colors.transparent,
    iconTheme: new IconThemeData(color: UiData.orange),
    primaryIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Color(0xFF1a1a1a),
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: UiData.orange,
          fontSize: 22),
      body1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: UiData.orange,
          fontSize: 18),
      body2: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: UiData.orange,
          fontSize: 16),
      caption: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.w500,
          color: UiData.orange,
          fontSize: 14),
    ),
  );
}

final ThemeData kAmoledTheme = _buildAmoledTheme();

ThemeData _buildAmoledTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Colors.black,
    accentColor: Colors.white,
    canvasColor: Colors.transparent,
    iconTheme: new IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Color(0xFF1a1a1a),
    textTheme: TextTheme(
      headline: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22),
      body1: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18),
      body2: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16),
      caption: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 14),
    ),
  );
}
