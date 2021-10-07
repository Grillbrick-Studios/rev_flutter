import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rev_flutter/src/models/appendices.dart';
import 'package:rev_flutter/src/models/bible.dart';
import 'package:rev_flutter/src/models/commentary.dart';
import 'package:rev_flutter/src/models/verse.dart';

import 'src/app.dart';
import 'src/settings/global_state.dart';
import 'src/settings/stored_state.dart';

void main() async {
  // Initialize hive for local storage.
  await Hive.initFlutter();
  Hive.registerAdapter(StyleAdapter());
  Hive.registerAdapter(VerseAdapter());
  Hive.registerAdapter(BibleAdapter());
  Hive.registerAdapter(CommentAdapter());
  Hive.registerAdapter(CommentaryAdapter());
  Hive.registerAdapter(AppendicesAdapter());
  Hive.registerAdapter(AppendixAdapter());

  // Set up the GlobalState, which will glue user settings to multiple
  // Flutter Widgets.
  final globalState = GlobalState(StoredState());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await globalState.loadSettings();

  // Run the app and pass in the GlobalState. The app listens to the
  // GlobalState for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    globalState: globalState,
  ));
}
