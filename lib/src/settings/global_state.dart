import 'package:flutter/material.dart';
import 'package:rev_flutter/src/models/bible.dart';

import 'stored_state.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class GlobalState with ChangeNotifier {
  GlobalState(this._store);

  // Make SettingsService a private variable so it is not used directly.
  final StoredState _store;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Make user font a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late TextStyle _textStyle;

  // Make user font size a private variable so it is not updated directly
  // without also persisting the changes with the SettingsService.
  late double _textSize;

  // Make the bible data private so it is not updated directly without also
  // persisting the changes.
  late Bible? _bible;

  // Make the book name private so it is not updated directly without also
  // persisting the changes.
  late String? _book;

  // Make the chapter private so it is not updated directly without also
  // persisting the changes.
  late int? _chapter;

  // Make the verse private so it is not updated directly without also
  // persisting the changes.
  late int? _verse;

  // Allow Widgets to read the user's preferred TextStyle.
  TextStyle get textStyle => _textStyle;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  // Allow Widgets to read the user's preferred Text Size
  double get textSize => _textSize;

  // Allow Widgets to get bible data.
  Bible? get bible => _bible;

  String? get book => _book;

  int? get chapter => _chapter;

  int? get verse => _verse;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _store.themeMode;
    _textStyle = await _store.textStyle;
    _textSize = await _store.textSize;
    // Load the bible data asyncronously
    _bible = null;
    _book = await _store.bookName;
    _chapter = await _store.chapter;
    _verse = await _store.verse;
    Bible.load().then((b) {
      _bible = b;
      notifyListeners();
    });

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the textStyle
  Future<void> updateTextStyle(TextStyle? newTextStyle) async {
    if (newTextStyle == null) return;

    if (newTextStyle == _textStyle) return;

    _textStyle = newTextStyle;

    notifyListeners();

    // Persist data
    await _store.updateTextStyle(newTextStyle);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _store.updateThemeMode(newThemeMode);
  }

  /// Update and persist the Text Size based on the user's selection.
  Future increaseTextSize([double amount = 2]) async {
    _textSize += amount;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _store.updateTextSize(_textSize);
  }

  Future decreaseTextSize([double amount = 2]) async {
    _textSize -= amount;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _store.updateTextSize(_textSize);
  }

  Future resetTextSize() async {
    _textSize = defaultTextSize;
  }

  Future updateBookName([String? book]) async {
    if (book == _book) return;

    _book = book;

    notifyListeners();

    await _store.updateBookName(book);
  }

  Future updateChapter([int? chapter]) async {
    if (chapter == chapter) return;

    _chapter = chapter;

    notifyListeners();

    await _store.updateChapter(chapter);
  }

  Future updateVerse([int? verse]) async {
    if (verse == verse) return;
    _verse = verse;
    notifyListeners();
    await _store.updateVerse(verse);
  }
}
