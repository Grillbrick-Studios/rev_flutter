import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fonts.dart' as fonts;

double defaultTextSize = 24;

/// Encode a theme into a string.
String _encodeThemeMode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.system:
      return 'system';
  }
}

/// Decode a theme from a string.
ThemeMode _decodeThemeMode(String mode) {
  switch (mode) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    try {
      var preferences = await SharedPreferences.getInstance();
      var themeString = preferences.getString('themeMode') ??
          _encodeThemeMode(ThemeMode.system);
      return _decodeThemeMode(themeString);
    } catch (err) {
      return ThemeMode.system;
    }
  }

  /// Loads the User's preferred TextStyle from local or remote storage.
  Future<TextStyle> textStyle() async {
    try {
      var preferences = await SharedPreferences.getInstance();
      var styleString =
          preferences.getString('textStyle') ?? fonts.simpleDefault.toString();
      return fonts.SimpleFont.fromString(styleString).style;
    } catch (err) {
      return fonts.defaultFont;
    }
  }

  /// Loads the User's preferred TextSize from local or remote storage.
  Future textSize() async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getDouble('textSize') ?? defaultTextSize;
    } catch (err) {
      return defaultTextSize;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future updateThemeMode(ThemeMode theme) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      preferences.setString('themeMode', _encodeThemeMode(theme));
    } catch (err) {
      throw Exception("Error getting SharedPreferences: $err");
    }
  }

  /// Persists the user's preferred TextStyle to local or remote storage.
  Future updateTextStyle(TextStyle style) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      // get the simpleFont
      var simpleFont = fonts.allFonts.firstWhere((f) => f.style == style,
          orElse: () => fonts.simpleDefault);
      preferences.setString('textStyle', simpleFont.toString());
    } catch (err) {
      throw Exception('Error getting SharedPreferences: $err');
    }
  }

  /// Persists the user's preferred TextSize to local or remote storage.
  Future updateTextSize(double size) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      preferences.setDouble('textSize', size);
    } catch (err) {
      throw Exception('Error getting SharedPreferences: $err');
    }
  }
}
