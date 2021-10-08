import 'package:flutter/material.dart';
import 'package:rev_flutter/src/settings/boxes.dart';

const tail = SizedBox(
  width: 100,
  height: 500,
  child: null,
);

class NavHeader extends StatelessWidget {
  const NavHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttons = <TextButton>[];

    if (Boxes.resource != null) {
      buttons.add(
        TextButton(
          onPressed: () => Boxes.resource = null,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))))),
          child: Text(
            Boxes.resource!.asString,
          ),
        ),
      );
    }

    if (Boxes.bookName != null) {
      buttons.add(
        TextButton(
          onPressed: () => Boxes.bookName = null,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))))),
          child: Text(
            Boxes.bookName.toString(),
          ),
        ),
      );
    }

    if (Boxes.chapter != null) {
      buttons.add(TextButton(
        onPressed: () => Boxes.chapter = null,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.resolveWith((states) =>
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))))),
        child: Text(
          Boxes.chapter.toString(),
        ),
      ));
    }

    if (Boxes.verse != null) {
      buttons.add(TextButton(
        onPressed: () => Boxes.verse = null,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.resolveWith((states) =>
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))))),
        child: Text(
          ':' + Boxes.verse.toString(),
        ),
      ));
    }
    return Row(
      children: buttons,
    );
  }
}
