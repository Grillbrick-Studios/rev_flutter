import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';
import 'package:rev_flutter/src/pages/loading_screen.dart';
import 'package:rev_flutter/src/settings/boxes.dart';

/// Displays the commentary for a particular verse
class CommentaryView extends StatelessWidget {
  const CommentaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Boxes.commentary == null) return const LoadingScreen();
    var commentary = Boxes.commentary!;
    return Column(
      children: [
        const NavHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Html(
                  data: commentary.getCommentary(Boxes.path!),
                ),
                // This adds some scroll past stuff
                tail,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
