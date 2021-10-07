import 'package:flutter/material.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/global_state.dart';
import '../settings/stored_state.dart';
import 'loading_screen.dart';

/// A list of verses to be displayed as buttons
class VerseList extends StatelessWidget {
  static const routeName = '/verses';
  final GlobalState state;

  const VerseList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BibleLike? resource;
    switch (state.resource) {
      case Resource.bible:
        resource = state.bible;
        break;
      case Resource.commentary:
        resource = state.commentary;
        break;
      case Resource.appendix:
        resource = state.appendix;
        break;
      default:
        resource = null;
        break;
    }
    if (resource == null) {
      return LoadingScreen(state: state);
    }
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[NavHeader(state: state)] +
            resource.listVerses(state.path!).map((verse) {
              Widget btnWidget = TextButton(
                onPressed: () => state.updateVerse(verse),
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
