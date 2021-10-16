import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'layout.dart';
import 'pages/home.dart';
import 'settings/boxes.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textTheme(BuildContext context) => TextTheme(
          headline1: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.7,
          ),
          headline2: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.6,
          ),
          headline3: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.5,
          ),
          headline4: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.4,
          ),
          headline5: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.3,
          ),
          headline6: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize * 1.25,
          ),
          bodyText1: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize,
          ),
          bodyText2: Boxes.textStyle.copyWith(
            fontSize: Boxes.textSize,
          ),
        );

    return ValueListenableBuilder(
        valueListenable: Boxes.preferenceBox.listenable(),
        builder: (BuildContext context, Box box, Widget? child) {
          ValueListenable? listenable;
          switch (Boxes.resource) {
            case Resource.bible:
              listenable = Boxes.bibleBox.listenable();
              break;
            case Resource.commentary:
              listenable = Boxes.commentaryBox.listenable();
              break;
            case Resource.appendix:
              listenable = Boxes.appendixBox.listenable();
              break;
            default:
              listenable = Boxes.preferenceBox.listenable();
          }
          return ValueListenableBuilder(
              valueListenable: listenable,
              builder: (BuildContext context, value, Widget? child) {
                return MaterialApp(
                    title: 'REV',
                    theme: ThemeData.from(
                      colorScheme: const ColorScheme.light(),
                      textTheme: textTheme(context),
                    ),
                    darkTheme: ThemeData.from(
                      colorScheme: const ColorScheme.dark(),
                      textTheme: textTheme(context),
                    ),
                    themeMode: Boxes.themeMode,
                    // Define a function to handle named routes in order to support
                    // Flutter web url navigation and deep linking.
                    onGenerateRoute: (RouteSettings routeSettings) {
                      return MaterialPageRoute<void>(
                          settings: routeSettings,
                          builder: (BuildContext context) {
                            switch (routeSettings.name) {
                              case SettingsView.routeName:
                                return const MyLayout(
                                  child: SettingsView(),
                                );
                              case Home.routeName:
                              default:
                                return const MyLayout(
                                  child: Home(),
                                );
                            }
                          });
                    });
              });
        });
  }
}
