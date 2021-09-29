import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/home.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

Widget wrapTarget(
    {required BuildContext context,
    required RouteSettings routeSettings,
    required Widget child}) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('REV'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Navigate to the settings page. If the user leaves and returns
            // to the app after it has been killed while running in the
            // background, the navigation stack is restored.
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    ),
    body: Container(
      margin: const EdgeInsets.all(6),
      child: child,
    ),
  );
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    textTheme(BuildContext context) => TextTheme(
          headline1: settingsController.textStyle.copyWith(
            fontSize: 36,
          ),
          headline2: settingsController.textStyle.copyWith(
            fontSize: 34,
          ),
          headline3: settingsController.textStyle.copyWith(
            fontSize: 30,
          ),
          headline4: settingsController.textStyle.copyWith(
            fontSize: 24,
          ),
          headline5: settingsController.textStyle.copyWith(
            fontSize: 20,
          ),
          headline6: settingsController.textStyle.copyWith(
            fontSize: 18,
          ),
          bodyText1: settingsController.textStyle,
          bodyText2: settingsController.textStyle,
        );
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
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
            AppLocalizations.delegate,
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
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

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
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return wrapTarget(
                      context: context,
                      routeSettings: routeSettings,
                      child: SettingsView(
                        controller: settingsController,
                      ),
                    );
                  case HelloWorld.routeName:
                  default:
                    // return const HelloWorld();
                    return wrapTarget(
                      context: context,
                      routeSettings: routeSettings,
                      child: const HelloWorld(),
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
