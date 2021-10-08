import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rev_flutter/src/layout.dart';

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
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (BuildContext context) => "REV",

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
        textTheme: textTheme(context),
      ),
      //(
      //fontFamily: settingsController.textStyle.fontFamily,
      //),
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
          },
        );
      },
    );
  }
}
