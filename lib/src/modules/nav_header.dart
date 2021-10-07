import 'package:flutter/material.dart';

import '../settings/global_state.dart';
import '../settings/stored_state.dart';

const tail = SizedBox(
  width: 100,
  height: 500,
  child: null,
);

class NavHeader extends StatelessWidget {
  final GlobalState state;

  const NavHeader({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttons = <TextButton>[];

    if (state.resource != null) {
      buttons.add(
        TextButton(
          onPressed: () => state.updateResource(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))))),
          child: Text(
            state.resource!.asString,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    }

    if (state.book != null) {
      buttons.add(
        TextButton(
          onPressed: () => state.updateBookName(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))))),
          child: Text(
            state.book.toString(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    }

    if (state.chapter != null) {
      buttons.add(TextButton(
        onPressed: () => state.updateChapter(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.resolveWith((states) =>
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))))),
        child: Text(
          state.chapter.toString(),
          style: Theme.of(context).textTheme.headline3,
        ),
      ));
    }

    if (state.verse != null) {
      buttons.add(TextButton(
        onPressed: () => state.updateVerse(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.resolveWith((states) =>
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))))),
        child: Text(
          ':' + state.verse.toString(),
          style: Theme.of(context).textTheme.headline3,
        ),
      ));
    }
    return Row(
      children: buttons,
    );
  }
}
