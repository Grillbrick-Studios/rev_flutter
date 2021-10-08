import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/boxes.dart';

void main() async {
  // Initialize hive for local storage.
  await Boxes.initialize();

  // Run the app and pass in the GlobalState. The app listens to the
  // GlobalState for changes, then passes it further down to the
  // SettingsView.
  runApp(const MyApp());
}
