import 'package:flutter/material.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/global_state.dart';
import '../settings/stored_state.dart';
import 'loading_screen.dart';

/// A page to list the book names of any resource.
/// A list of books to be displayed as buttons
class BookList extends StatelessWidget {
  static const routeName = '/books';
  final GlobalState state;

  const BookList({Key? key, required this.state}) : super(key: key);

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
    if (resource != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[NavHeader(state: state)] +
              resource.listBooks.map((bookName) {
                List<Widget> heading = [];
                Widget btnWidget = TextButton(
                  onPressed: () => state.updateBookName(bookName),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))))),
                  child: Text(
                    bookName,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
                if (bookName.startsWith('Gen')) {
                  heading.add(Row(children: [
                    Text(
                      'Old Testament',
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ]));
                } else if (bookName.startsWith('Mat')) {
                  heading.add(Row(
                    children: [
                      Text(
                        'New Testament',
                        style: Theme.of(context).textTheme.headline2,
                      )
                    ],
                  ));
                }
                return [...heading, btnWidget];
              }).reduce((value, element) {
                value.addAll(element);
                return value;
              }) +
              [
                // This adds some scroll past stuff
                const SizedBox(
                  width: 100,
                  height: 500,
                  child: null,
                )
              ],
        ),
      );
    } else {
      return LoadingScreen(
        state: state,
      );
    }
  }
}
