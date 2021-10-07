import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

import 'loading_screen.dart';

class AppendixView extends StatelessWidget {
  static const routeName = '/resources/appendix';
  final GlobalState state;

  const AppendixView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.appendix == null) return LoadingScreen(state: state);
    final appendix = state.appendix!;
    return Wrap(
      children: [
        NavHeader(state: state),
        SingleChildScrollView(
          child: Html(
            data: appendix.getAppendix(state.book!),
          ),
        )
      ],
    );
  }
}
