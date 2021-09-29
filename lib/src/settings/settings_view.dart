import 'package:flutter/material.dart';

import 'fonts.dart' as fonts;
import 'settings_controller.dart';

/// Displays a single setting in a row with a header and dropdown.
class SettingsDropdown<T> extends StatelessWidget {
  const SettingsDropdown(this.title,
      {Key? key,
      required this.value,
      required this.onUpdate,
      required this.options})
      : super(key: key);

  final String title;
  final T value;
  final Function(T?)? onUpdate;
  final List<DropdownMenuItem<T>> options;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButton<T>(
              value: value, onChanged: onUpdate, items: options),
        ),
      ],
    );
  }
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsDropdown(
          'Color Theme',
          onUpdate: controller.updateThemeMode,
          value: controller.themeMode,
          options: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark Theme'),
            ),
          ],
        ),
        SettingsDropdown<TextStyle>(
          'Text Font',
          value: controller.textStyle,
          onUpdate: controller.updateTextStyle,
          options: [
            DropdownMenuItem(
              child: Text(
                'Serifed Fonts',
                style: fonts.lightFont,
              ),
              enabled: false,
            ),
            ...fonts.serifFonts.map((font) => DropdownMenuItem(
                  value: font.style,
                  child: Text(
                    font.label,
                    style: font.style,
                  ),
                )),
            DropdownMenuItem(
              child: Text(
                'Non-Serifed Fonts',
                style: fonts.lightFont,
              ),
              enabled: false,
            ),
            ...fonts.nonSerifFonts.map((font) => DropdownMenuItem(
                  value: font.style,
                  child: Text(
                    font.label,
                    style: font.style,
                  ),
                )),
            DropdownMenuItem(
              child: Text(
                'Fancy Fonts',
                style: fonts.lightFont,
              ),
              enabled: false,
            ),
            ...fonts.fancyFonts.map((font) => DropdownMenuItem(
                  value: font.style,
                  child: Text(
                    font.label,
                    style: font.style,
                  ),
                )),
          ],
        ),
        const Text('''
              This is a bunch of text to get a feel for the selected font.
Ultricies dui. Cras gravida rutrum massa. Donec accumsan mattis turpis. Quisque sem. Quisque elementum sapien iaculis augue. In dui sem, congue sit amet, feugiat quis, lobortis at, eros. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum vehicula purus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean risus dui, volutpat non, posuere vitae, sollicitudin in, urna. Nam eget eros a enim pulvinar rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla facilisis massa ut massa. Sed nisi purus, malesuada eu, porta vulputate, suscipit auctor, nunc. Vestibulum convallis, augue eu luctus.
            ''')
      ],
    );
  }
}
//Padding(
//padding: const EdgeInsets.all(16),
//// Glue the SettingsController to the theme selection DropdownButton.
////
//// When a user selects a theme from the dropdown list, the
//// SettingsController is updated, which rebuilds the MaterialApp.
//child: DropdownButton<ThemeMode>(
//// Read the selected themeMode from the controller
//value: controller.themeMode,
//// Call the updateThemeMode method any time the user selects a theme.
//onChanged: controller.updateThemeMode,
//items: const [
//DropdownMenuItem(
//value: ThemeMode.system,
//child: Text('System Theme'),
//),
//DropdownMenuItem(
//value: ThemeMode.light,
//child: Text('Light Theme'),
//),
//DropdownMenuItem(
//value: ThemeMode.dark,
//child: Text('Dark Theme'),
//)
//],
//),
//),
//Padding(
//padding: const EdgeInsets.all(16),
//child: DropdownButton<TextStyle>(
//value: controller.textStyle,
//onChanged: controller.updateTextStyle,
//items: [
//DropdownMenuItem(
//child: Text(
//'Serifed Fonts',
//style: fonts.lightFont,
//),
//enabled: false,
//),
//...fonts.serifFonts.map((font) => DropdownMenuItem(
//value: font.style,
//child: Text(
//font.label,
//style: font.style,
//),
//)),
//DropdownMenuItem(
//child: Text(
//'Non-Serifed Fonts',
//style: fonts.lightFont,
//),
//enabled: false,
//),
//...fonts.nonSerifFonts.map((font) => DropdownMenuItem(
//value: font.style,
//child: Text(
//font.label,
//style: font.style,
//),
//)),
//DropdownMenuItem(
//child: Text(
//'Fancy Fonts',
//style: fonts.lightFont,
//),
//enabled: false,
//),
//...fonts.fancyFonts.map((font) => DropdownMenuItem(
//value: font.style,
//child: Text(
//font.label,
//style: font.style,
//),
//)),
