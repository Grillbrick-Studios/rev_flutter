import 'package:flutter/material.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NavHeader(),
        Expanded(
            child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ))
      ],
    );
  }
}
