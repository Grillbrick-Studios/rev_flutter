import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rev_flutter/src/settings/boxes.dart';

import 'fonts.dart' as fonts;

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
            value: value,
            onChanged: onUpdate,
            items: options,
          ),
        ),
      ],
    );
  }
}

/// Displays a single setting in a row with a header and buttons for
/// increase/decrease and optional reset.
class SettingsButtons extends StatelessWidget {
  const SettingsButtons({
    Key? key,
    required this.title,
    required this.onIncrease,
    required this.onDecrease,
    this.onReset,
  }) : super(key: key);

  final String title;
  final void Function() onIncrease;
  final void Function() onDecrease;
  final void Function()? onReset;

  @override
  Widget build(BuildContext context) {
    return onReset == null
        ? Row(children: [
            Text(title),
            IconButton(
                onPressed: onDecrease, icon: const Icon(CupertinoIcons.minus)),
            IconButton(
                onPressed: onIncrease, icon: const Icon(CupertinoIcons.plus)),
          ])
        : Row(children: [
            Text(title),
            IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove)),
            IconButton(onPressed: onIncrease, icon: const Icon(Icons.add)),
            IconButton(onPressed: onReset, icon: const Icon(Icons.refresh))
          ]);
  }
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsDropdown(
            'Color Theme',
            onUpdate: (dynamic mode) => Boxes.themeMode = mode,
            value: Boxes.themeMode,
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
            value: Boxes.textStyle,
            onUpdate: (dynamic style) => Boxes.textStyle = style,
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
          SettingsButtons(
            title: 'Font Size',
            onIncrease: _onIncreaseFontSize,
            onDecrease: _onDecreaseFontSize,
            onReset: _onResetFontSize,
          ),
          const Text('''
              This is a bunch of text to get a feel for the selected font.
Ultricies dui. Crass gravid rostrum mass. Done accompany mattes turps. Quisque sem. Quisque elementum sapien iaculis augue. In dui sem, congue sit amet, feugiat quis, lobortis at, eros. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum vehicula purus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean risus dui, volutpat non, posuere vitae, sollicitudin in, urna. Nam eget eros a enim pulvinar rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla facilisis massa ut massa. Sed nisi purus, malesuada eu, porta vulputate, suscipit auctor, nunc. Vestibulum convallis, augue eu luctus.
            ''')
        ],
      ),
    );
  }

  void _onIncreaseFontSize() {
    Boxes.textSize += 0.5;
  }

  void _onDecreaseFontSize() {
    Boxes.textSize -= 0.5;
  }

  void _onResetFontSize() {
    Boxes.textSize = defaultTextSize;
  }
}
