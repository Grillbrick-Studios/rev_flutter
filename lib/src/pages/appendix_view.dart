import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rev_flutter/src/settings/boxes.dart';

import '../modules/nav_header.dart';
import 'loading_screen.dart';

class AppendixView extends StatelessWidget {
  static const routeName = '/resources/appendix';

  const AppendixView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Boxes.appendices == null) return const LoadingScreen();
    final appendix = Boxes.appendices!;
    return Column(
      children: [
        const NavHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Html(
                  data: appendix.getAppendix(Boxes.bookName!),
                ),
                tail,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
