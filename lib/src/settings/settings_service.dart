import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fonts.dart' as fonts;

/// Encode a theme into a string.
String encodeThemeMode(ThemeMode mode) {
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
ThemeMode decodeThemeMode(String mode) {
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
    var preferences = await SharedPreferences.getInstance();
    var themeString =
        preferences.getString('themeMode') ?? encodeThemeMode(ThemeMode.system);
    return decodeThemeMode(themeString);
  }

  /// Loads the User's preferred TextStyle from local or remote storage.
  Future<TextStyle> textStyle() async {
    var preferences = await SharedPreferences.getInstance();
    var styleString =
        preferences.getString('textStyle') ?? fonts.simpleDefault.toString();
    return fonts.SimpleFont.fromString(styleString).style;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('themeMode', encodeThemeMode(theme));
  }

  /// Persists the user's preferred TextStyle to local or remote storage.
  Future<void> updateTextStyle(TextStyle newTextStyle) async {
    var preferences = await SharedPreferences.getInstance();
    // get the simpleFont
    var simpleFont = fonts.allFonts.firstWhere((f) => f.style == newTextStyle,
        orElse: () => fonts.simpleDefault);
    preferences.setString('textStyle', simpleFont.toString());
  }
}
