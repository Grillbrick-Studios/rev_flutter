import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/bible.dart';
import '../modules/nav_header.dart';
import '../settings/global_state.dart';
import '../settings/stored_state.dart';
import 'loading_screen.dart';

/// Displays the chapter in an HTML view.
class ChapterView extends StatelessWidget {
  static const routeName = '/chapter-view';
  final GlobalState state;

  const ChapterView({Key? key, required this.state}) : super(key: key);

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
      return LoadingScreen(
        state: state,
      );
    }
    final bible = state.bible!;
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: <Widget>[
        NavHeader(state: state),
        SingleChildScrollView(
          child: Html(data: bible.getChapter(state.path!)),
        ),
        // This adds some scroll past stuff
        const SizedBox(
          width: 100,
          height: 500,
          child: null,
        )
      ],
    );
  }
}
