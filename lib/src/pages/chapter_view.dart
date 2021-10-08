import 'package:flutter/material.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/boxes.dart';
import 'loading_screen.dart';

/// Displays the chapter in an HTML view.
class ChapterView extends StatelessWidget {
  static const routeName = '/chapter-view';

  const ChapterView({Key? key}) : super(key: key);

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
    final bible = Boxes.bible!;
    return Column(
      // spacing: 20,
      // runSpacing: 20,
      children: <Widget>[
        const NavHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              bible.getChapter(Boxes.path!),
              softWrap: true,
            ),
            // child: Html(
            //   data: bible.getChapter(Boxes.path!),
            //   style: {
            //     '.title': Style(
            //       textAlign: TextAlign.center,
            //       fontSize: FontSize.percent(150),
            //     ),
            //     '.start': Style(
            //       textAlign: TextAlign.start,
            //     ),
            //     '.versebreak': Style(
            //       display: Display.BLOCK,
            //       margin: const EdgeInsets.symmetric(vertical: 20.0),
            //     ),
            //     '.heading': Style(
            //       fontSize: FontSize.percent(110),
            //       fontWeight: FontWeight.w700,
            //       fontStyle: FontStyle.italic,
            //       margin: const EdgeInsets.only(bottom: 0.2),
            //     ),
            //     '.microheading': Style(
            //       display: Display.BLOCK,
            //       margin: const EdgeInsets.only(
            //         top: 1,
            //         bottom: 0.2,
            //       ),
            //       fontSize: FontSize.percent(76),
            //       fontStyle: FontStyle.italic,
            //       color: Colors.grey,
            //     ),
            //     '.questionable': Style(
            //       fontStyle: FontStyle.italic,
            //       fontWeight: FontWeight.w300,
            //     ),
            //     '.prose': Style(
            //       display: Display.BLOCK,
            //       margin: const EdgeInsets.only(top: 1),
            //       textAlign: TextAlign.start,
            //     ),
            //     '.poetry': Style(
            //       display: Display.BLOCK,
            //       margin: const EdgeInsets.only(
            //         left: 1,
            //         right: 1,
            //         bottom: 1,
            //       ),
            //       textAlign: TextAlign.start,
            //     ),
            //   },
            //   onLinkTap: (src, context, map, element) {
            //     if (src == null) return;
            //     Boxes.verse = int.parse(src);
            //     Boxes.resource = Resource.commentary;
            //   },
            // ),
          ),
        ),
      ],
    );
  }
}
