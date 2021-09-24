import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fonts.dart' as fonts;

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    //var preferences = await SharedPreferences.getInstance();
    //return preferences.getString('themeMode') as ThemeMode? ?? ThemeMode.system;
    return ThemeMode.system;
  }

  Future<TextStyle> textStyle() async {
    //var preferences = await SharedPreferences.getInstance();
    //return preferences.getString('textStyle') as TextStyle? ?? fonts.defaultFont;
    return fonts.defaultFont;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('themeMode', theme.toString());
  }

  Future<void> updateTextStyle(TextStyle newTextStyle) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('textStyle', newTextStyle.toString());
  }
}
