import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rev_flutter/src/pages/appendix_view.dart';
import 'package:rev_flutter/src/pages/book_list.dart';
import 'package:rev_flutter/src/pages/chapter_list.dart';
import 'package:rev_flutter/src/pages/chapter_view.dart';
import 'package:rev_flutter/src/pages/resource_list.dart';
import 'package:rev_flutter/src/pages/verse_list.dart';
import 'package:rev_flutter/src/settings/boxes.dart';

import 'commentary_view.dart';

/// The Home Page to display data.
class Home extends StatelessWidget {
  static const routeName = '/';

  /// A constructor that gets the global state.
  const Home({Key? key}) : super(key: key);

  /// Basic Widget override of build
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Boxes.preferenceBox.listenable(),
        builder: (context, Box box, child) {
          final ValueListenable? listenable;
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
              break;
          }

          return ValueListenableBuilder(
              valueListenable: listenable,
              builder: (context, box, child) {
                return Boxes.resource == null
                    ? const ResourceList()
                    : Boxes.bookName == null
                        ? const BookList()
                        : Boxes.resource == Resource.appendix
                            ? const AppendixView()
                            : Boxes.chapter == null
                                ? const ChapterList()
                                : Boxes.resource == Resource.bible
                                    ? const ChapterView()
                                    : Boxes.verse == null
                                        ? const VerseList()
                                        : const CommentaryView();
              });
        });
  }
}
