import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';
import 'package:rev_flutter/src/pages/loading_screen.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

/// Displays the commentary for a particular verse
class CommentaryView extends StatelessWidget {
  final GlobalState state;

  const CommentaryView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.commentary == null) return LoadingScreen(state: state);
    var commentary = state.commentary!;
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: <Widget>[
        NavHeader(state: state),
        SingleChildScrollView(
          child: Html(
            data: commentary.getCommentary(state.path!),
          ),
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
