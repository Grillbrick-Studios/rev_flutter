import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fonts.dart' as fonts;

/// An enum for each Resource
enum Resource {
  bible,
  commentary,
  appendix,
}

extension IntMaker on Resource {
  int get toInt {
    switch (this) {
      case Resource.bible:
        return 1;
      case Resource.commentary:
        return 2;
      case Resource.appendix:
        return 3;
    }
  }

  String get asString {
    switch (this) {
      case Resource.bible:
        return 'Bible';
      case Resource.commentary:
        return 'Commentary';
      case Resource.appendix:
        return 'Appendices';
    }
  }
}

extension ResourceMaker on int {
  Resource? get toResource {
    switch (this) {
      case 1:
        return Resource.bible;
      case 2:
        return Resource.commentary;
      case 3:
        return Resource.appendix;
    }
  }
}

double defaultTextSize = 24;

/// Encode a theme into a string.
extension Stringifier on ThemeMode {
  String get asString {
    switch (this) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}

/// Decode a theme from a string.
extension Themeifier on String {
  ThemeMode get toThemeMode {
    switch (this) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class StoredState {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future get themeMode async {
    try {
      var preferences = await SharedPreferences.getInstance();
      var themeString =
          preferences.getString('themeMode') ?? (ThemeMode.system.asString);
      return (themeString.toThemeMode);
    } catch (err) {
      return ThemeMode.system;
    }
  }

  /// Loads the User's preferred TextStyle from local or remote storage.
  Future get textStyle async {
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
  Future get textSize async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getDouble('textSize') ?? defaultTextSize;
    } catch (err) {
      return defaultTextSize;
    }
  }

  Future get bookName async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getString('book');
    } catch (err) {
      return null;
    }
  }

  Future get verse async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getInt('verse');
    } catch (err) {
      return null;
    }
  }

  Future get chapter async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getInt('chapter');
    } catch (err) {
      return null;
    }
  }

  /// Loads the User's last used Resource if it exists.
  Future get resource async {
    try {
      var preferences = await SharedPreferences.getInstance();
      return preferences.getInt('resource')?.toResource;
    } catch (err) {
      return null;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future updateThemeMode(ThemeMode theme) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      preferences.setString('themeMode', theme.asString);
    } catch (err) {
      throw Exception("Error getting SharedPreferences: $err");
    }
  }

  Future updateResource(Resource? resource) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      if (resource == null) {
        preferences.remove('resource');
      } else {
        preferences.setInt('resource', resource.toInt);
      }
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

  Future updateBookName(String? book) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      if (book == null) {
        preferences.remove('book');
      } else {
        preferences.setString('book', book);
      }
    } catch (err) {
      throw Exception('Error getting SharedPreferences: $err');
    }
  }

  Future updateChapter(int? chapter) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      if (chapter == null) {
        preferences.remove('chapter');
      } else {
        preferences.setInt('chapter', chapter);
      }
    } catch (err) {
      throw Exception('Error getting SharedPreferences: $err');
    }
  }

  Future updateVerse(int? verse) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      if (verse == null) {
        preferences.remove('verse');
      } else {
        preferences.setInt('verse', verse);
      }
    } catch (err) {
      throw Exception('Error getting SharedPreferences: $err');
    }
  }
}
