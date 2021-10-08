import 'package:flutter/material.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/boxes.dart';
import 'loading_screen.dart';

/// A list of verses to be displayed as buttons
class VerseList extends StatelessWidget {
  static const routeName = '/verses';

  const VerseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BibleLike? resource;
    switch (Boxes.resource) {
      case Resource.bible:
        resource = Boxes.bible;
        break;
      case Resource.commentary:
        resource = Boxes.commentary;
        break;
      case Resource.appendix:
        resource = Boxes.appendices;
        break;
      default:
        resource = null;
        break;
    }
    if (resource == null) {
      return const LoadingScreen();
    }
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[const NavHeader()] +
            resource.listVerses(Boxes.path!).map((verse) {
              Widget btnWidget = TextButton(
                onPressed: () => Boxes.verse = verse,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.resolveWith((states) =>
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))))),
                child: Text(
                  verse.toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
              );
              return btnWidget;
            }).toList() +
            [
              // This adds some scroll past stuff
              tail,
            ],
      ),
    );
  }
}
