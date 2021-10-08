import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rev_flutter/src/models/appendices.dart';
import 'package:rev_flutter/src/models/bible.dart';
import 'package:rev_flutter/src/models/commentary.dart';
import 'package:rev_flutter/src/models/verse.dart';

import 'fonts.dart' as fonts;

part 'boxes.g.dart';

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

extension ResourceString on Resource {
  String get asString {
    switch (this) {
      case Resource.bible:
        return 'bible';
      case Resource.commentary:
        return 'commentary';
      case Resource.appendix:
        return 'appendix';
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
ThemeMode themeModeFromString(String s) {
  switch (s) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

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

class Boxes {
  /// Private constants to hold the names of boxes.
  ///
  /// The appendix box path
  static const String _appendices = 'appendices';

  /// The bible box path
  static const String _bible = 'bible';

  /// The commentary box path
  static const String _commentary = 'commentary';

  /// The preferences box path for smaller preferences.
  static const String _preferences = 'preferences';

  /// Tracking initialization
  ///
  /// [ _initialized ] tracks if the boxes have been initialized.
  static bool _initialized = false;

  /// Whereas [ initialize() ] is used to perform the initialization.
  static Future initialize() async {
    // initialize only once.
    if (_initialized) return;

    await Hive.initFlutter();
    Hive.registerAdapter(ResourceAdapter());
    Hive.registerAdapter(StyleAdapter());
    Hive.registerAdapter(VerseAdapter());
    Hive.registerAdapter(BibleAdapter());
    Hive.registerAdapter(CommentAdapter());
    Hive.registerAdapter(CommentaryAdapter());
    Hive.registerAdapter(AppendicesAdapter());
    Hive.registerAdapter(AppendixAdapter());

    await Hive.openBox(_preferences);
    var bible = await Hive.openBox<Bible?>(_bible);
    var appendix = await Hive.openBox<Appendices?>(_appendices);
    var commentary = await Hive.openBox<Commentary?>(_commentary);

    if (commentary.get(0) == null) {
      Commentary.load;
    }
    if (appendix.get(0) == null) {
      Appendices.load;
    }
    if (bible.get(0) == null) {
      Bible.load;
    }

    _initialized = true;
  }

  /// getters for each box
  ///
  /// [ bibleBox ] is the box that holds bible data.
  static Box<Bible?> get bibleBox => Hive.box<Bible?>(_bible);

  /// [appendixBox] is the box that holds the appendix data.
  static Box<Appendices?> get appendixBox => Hive.box<Appendices?>(_appendices);

  /// [ commentaryBox ] is the box that holds commentary info.
  static Box<Commentary?> get commentaryBox =>
      Hive.box<Commentary?>(_commentary);

  /// finally [preferenceBox] holds various preferences and states that are
  /// used throughout the app.
  static Box<dynamic> get preferenceBox => Hive.box(_preferences);

  /// getters and setters for large resources
  static Bible? get bible => bibleBox.get(0);
  static set bible(Bible? b) => bibleBox.put(0, b);
  static Appendices? get appendices => appendixBox.get(0);
  static set appendices(Appendices? a) => appendixBox.put(0, a);
  static Commentary? get commentary => commentaryBox.get(0);
  static set commentary(Commentary? c) => commentaryBox.put(0, c);

  static ThemeMode get themeMode => themeModeFromString(
      preferenceBox.get('themeMode', defaultValue: ThemeMode.system.asString));
  static set themeMode(ThemeMode mode) =>
      preferenceBox.put('themeMode', mode.asString);

  static TextStyle get textStyle {
    var styleString = preferenceBox.get('textStyle',
        defaultValue: fonts.simpleDefault.toString());
    return fonts.SimpleFont.fromString(styleString).style;
  }

  static set textStyle(TextStyle style) {
    var simpleFont = fonts.allFonts
        .firstWhere((f) => f.style == style, orElse: () => fonts.simpleDefault);
    preferenceBox.put('textStyle', simpleFont.toString());
  }

  static double get textSize =>
      preferenceBox.get('textSize', defaultValue: defaultTextSize);
  static set textSize(double size) {
    preferenceBox.put('textSize', size);
  }

  static Resource? get resource => preferenceBox.get('resource');
  static set resource(Resource? r) {
    if (r == null) bookName = null;
    preferenceBox.put('resource', r);
  }

  static String? get bookName => preferenceBox.get('book');
  static set bookName(String? book) {
    if (book == null) chapter = null;
    preferenceBox.put('book', book);
  }

  static int? get chapter => preferenceBox.get('chapter');
  static set chapter(int? ch) {
    if (ch == null) verse = null;
    preferenceBox.put('chapter', ch);
  }

  static int? get verse => preferenceBox.get('verse');
  static set verse(int? v) => preferenceBox.put('verse', v);

  static BiblePath? get path =>
      bookName != null ? BiblePath(bookName!, chapter, verse) : null;
}
