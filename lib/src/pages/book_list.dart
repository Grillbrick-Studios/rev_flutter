import 'package:flutter/material.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/boxes.dart';
import 'loading_screen.dart';

/// A page to list the book names of any resource.
/// A list of books to be displayed as buttons
class BookList extends StatelessWidget {
  static const routeName = '/books';

  const BookList({Key? key}) : super(key: key);

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
    if (resource != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[const NavHeader()] +
              resource.listBooks.map((bookName) {
                List<Widget> heading = [];
                Widget btnWidget = TextButton(
                  onPressed: () => Boxes.bookName = bookName,
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
                tail,
              ],
        ),
      );
    } else {
      return const LoadingScreen();
    }
  }
}
