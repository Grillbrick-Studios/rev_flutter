import 'package:flutter/material.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

import '../models/bible.dart';

/// A simple Widget that presents a hello world screen.
class HelloWorld extends StatefulWidget {
  const HelloWorld({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  Bible? bible;

  @override
  Widget build(BuildContext context) {
    if (bible != null) {
      return ListView(
        children: bible!.listBooks
            .map((b) => Text(
                  b,
                  style: Theme.of(context).textTheme.headline1,
                ))
            .toList(),
      );
    } else {
      Bible.load().then((b) => setState(() {
            bible = b;
          }));
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }
}

/// The Home Page to display data.
class Home extends StatelessWidget {
  static const routeName = '/';
  final GlobalState state;

  /// A constructor that gets the global state.
  const Home({Key? key, required this.state}) : super(key: key);

  /// A list of books to be displayed as buttons
  Widget getBooks(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: state.bible!.listBooks.map((bookName) {
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
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }

  /// A list of chapters to be displayed as buttons
  Widget getChapters(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
                Row(
                  children: [
                    TextButton(
                      onPressed: () => state.updateBookName(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.book.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    )
                  ],
                )
              ] +
              state.bible!.listChapters(book: state.book!).map((chapter) {
                Widget btnWidget = TextButton(
                  onPressed: () => state.updateChapter(chapter),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))))),
                  child: Text(
                    chapter.toString(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
                return btnWidget;
              }).toList() +
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
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }

  /// A list of verses to be displayed as buttons
  Widget getVerses(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
                Row(
                  children: [
                    TextButton(
                      onPressed: () => state.updateBookName(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.book.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    TextButton(
                      onPressed: () => state.updateChapter(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.chapter.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    )
                  ],
                )
              ] +
              state.bible!
                  .listVerses(book: state.book!, chapter: state.chapter!)
                  .map((verse) {
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
                const SizedBox(
                  width: 100,
                  height: 500,
                  child: null,
                )
              ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }

  /// A list of tokens from the selected verse
  Widget getTokens(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
                Row(
                  children: [
                    TextButton(
                      onPressed: () => state.updateBookName(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.book.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    TextButton(
                      onPressed: () => state.updateChapter(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.chapter.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    TextButton(
                      onPressed: () => state.updateVerse(),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      child: Text(
                        state.verse.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    )
                  ],
                )
              ] +
              state.bible!
                  .listTokens(
                      book: state.book!,
                      chapter: state.chapter!,
                      verse: state.verse!)
                  .map((token) {
                return Row(
                  children: [
                    Text(
                      token.src,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                );
              }).toList() +
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
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return state.book == null
        ? getBooks(context)
        : state.chapter == null
            ? getChapters(context)
            : state.verse == null
                ? getVerses(context)
                : getTokens(context);
  }
}
