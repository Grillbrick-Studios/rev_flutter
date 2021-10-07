import 'package:flutter/material.dart';
import 'package:rev_flutter/src/pages/appendix_view.dart';
import 'package:rev_flutter/src/pages/book_list.dart';
import 'package:rev_flutter/src/pages/chapter_list.dart';
import 'package:rev_flutter/src/pages/chapter_view.dart';
import 'package:rev_flutter/src/pages/resource_list.dart';
import 'package:rev_flutter/src/pages/verse_list.dart';
import 'package:rev_flutter/src/settings/global_state.dart';
import 'package:rev_flutter/src/settings/stored_state.dart';

import 'commentary_view.dart';

/// The Home Page to display data.
class Home extends StatelessWidget {
  static const routeName = '/';
  final GlobalState state;

  /// A constructor that gets the global state.
  const Home({Key? key, required this.state}) : super(key: key);

  /// Basic Widget override of build
  @override
  Widget build(BuildContext context) {
    return state.resource == null
        ? ResourceList(state: state)
        : state.book == null
            ? BookList(state: state)
            : state.resource == Resource.appendix
                ? AppendixView(state: state)
                : state.chapter == null
                    ? ChapterList(state: state)
                    : state.resource == Resource.bible
                        ? ChapterView(state: state)
                        : state.verse == null
                            ? VerseList(state: state)
                            : CommentaryView(state: state);
  }
}
