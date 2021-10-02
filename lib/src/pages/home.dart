import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';
import 'package:rev_flutter/src/settings/global_state.dart';
import 'package:rev_flutter/src/settings/stored_state.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Loading Data...',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

/// The Home Page to display data.
class Home extends StatelessWidget {
  static const routeName = '/';
  final GlobalState state;

  /// A constructor that gets the global state.
  const Home({Key? key, required this.state}) : super(key: key);

  /// A list of resources to be displayed as buttons
  Widget getResources(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            NavHeader(state: state),
            ...Resource.values
                .map((e) => TextButton(
                      onPressed: () => state.updateResource(e),
                      child: Text(
                        e.asString,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ))
                .toList(),
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
      return const LoadingScreen();
    }
  }

  /// A list of books to be displayed as buttons
  Widget getBooks(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[NavHeader(state: state)] +
              state.bible!.listBooks.map((bookName) {
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
      return const LoadingScreen();
    }
  }

  /// A list of chapters to be displayed as buttons
  Widget getChapters(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[NavHeader(state: state)] +
              state.bible!.listChapters(state.path!).map((chapter) {
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
      return const LoadingScreen();
    }
  }

  /// A list of verses to be displayed as buttons
  Widget getVerses(BuildContext context) {
    if (state.bible != null) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[NavHeader(state: state)] +
              state.bible!.listVerses(state.path!).map((verse) {
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
      return const LoadingScreen();
    }
  }

  /// Displays the chapter in an HTML view.
  Widget getChapter(BuildContext context) {
    if (state.bible == null) return const LoadingScreen();
    final bible = state.bible!;
    return Html(data: bible.getChapter(state.path!));
  }

  @override
  Widget build(BuildContext context) {
    return state.resource == null
        ? getResources(context)
        : state.book == null
            ? getBooks(context)
            : state.resource == Resource.appendix
                ? getAppendix(context)
                : state.chapter == null
                    ? getChapters(context)
                    : state.resource == Resource.bible
                        ? getChapter(context)
                        : state.verse == null
                            ? getVerses(context)
                            : getVerses(context);
  }

  getAppendix(BuildContext context) {
    if (state.appendix == null) return const LoadingScreen();
    final appendix = state.appendix!;
    return Html(data: appendix.getAppendix(state.book!));
  }
}
