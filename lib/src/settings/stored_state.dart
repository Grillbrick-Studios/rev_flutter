import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'fonts.dart' as fonts;

part 'stored_state.g.dart';

class Boxes {
  static const String appendices = 'appendices';
  static const String bible = 'bible';
  static const String commentary = 'commentary';
  static const String preferences = 'preferences';
}

/// An enum for each Resource
@HiveType(typeId: 7)
enum Resource {
  @HiveField(0)
  bible,
  @HiveField(1)
  commentary,
  @HiveField(2)
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
  ThemeMode get themeMode {
    try {
      var preferences = Hive.box(Boxes.preferences);
      var mode = preferences.get('themeMode') ?? (ThemeMode.system.asString);
      return mode.toThemeMode();
    } catch (err) {
      return ThemeMode.system;
    }
  }

  /// Loads the User's preferred TextStyle from local or remote storage.
  TextStyle get textStyle {
    try {
      var preferences = Hive.box(Boxes.preferences);
      var styleString = preferences.get('textStyle') ?? fonts.simpleDefault;
      return fonts.SimpleFont.fromString(styleString).style;
    } catch (err) {
      return fonts.defaultFont;
    }
  }

  /// Loads the User's preferred TextSize from local or remote storage.
  double get textSize {
    try {
      var preferences = Hive.box(Boxes.preferences);
      return preferences.get('textSize') ?? defaultTextSize;
    } catch (err) {
      return defaultTextSize;
    }
  }

  String? get bookName {
    try {
      var preferences = Hive.box(Boxes.preferences);
      return preferences.get('book');
    } catch (err) {
      return null;
    }
  }

  int? get verse {
    try {
      var preferences = Hive.box(Boxes.preferences);
      return preferences.get('verse');
    } catch (err) {
      return null;
    }
  }

  int? get chapter {
    try {
      var preferences = Hive.box(Boxes.preferences);
      return preferences.get('chapter');
    } catch (err) {
      return null;
    }
  }

  /// Loads the User's last used Resource if it exists.
  Resource? get resource {
    try {
      var preferences = Hive.box(Boxes.preferences);
      return preferences.get('resource')?.toResource;
    } catch (err) {
      return null;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  updateThemeMode(ThemeMode theme) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      preferences.put('themeMode', theme.asString);
    } catch (err) {
      throw Exception("Error getting Hive.Box: $err");
    }
  }

  updateResource(Resource? resource) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      if (resource == null) {
        preferences.delete('resource');
      } else {
        preferences.put('resource', resource.toInt);
      }
    } catch (err) {
      throw Exception("Error getting Hive.Box: $err");
    }
  }

  /// Persists the user's preferred TextStyle to local or remote storage.
  updateTextStyle(TextStyle style) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      // get the simpleFont
      var simpleFont = fonts.allFonts.firstWhere((f) => f.style == style,
          orElse: () => fonts.simpleDefault);
      preferences.put('textStyle', simpleFont.toString());
    } catch (err) {
      throw Exception('Error getting Hive.Box: $err');
    }
  }

  /// Persists the user's preferred TextSize to local or remote storage.
  updateTextSize(double size) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      preferences.put('textSize', size);
    } catch (err) {
      throw Exception('Error getting Hive.Box: $err');
    }
  }

  updateBookName(String? book) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      if (book == null) {
        preferences.delete('book');
      } else {
        preferences.put('book', book);
      }
    } catch (err) {
      throw Exception('Error getting Hive.Box: $err');
    }
  }

  updateChapter(int? chapter) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      if (chapter == null) {
        preferences.delete('chapter');
      } else {
        preferences.put('chapter', chapter);
      }
    } catch (err) {
      throw Exception('Error getting Hive.Box: $err');
    }
  }

  updateVerse(int? verse) {
    try {
      var preferences = Hive.box(Boxes.preferences);
      if (verse == null) {
        preferences.delete('verse');
      } else {
        preferences.put('verse', verse);
      }
    } catch (err) {
      throw Exception('Error getting Hive.Box: $err');
    }
  }
}
