import 'package:flutter/material.dart';
import 'package:rev_flutter/src/modules/nav_header.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

class LoadingScreen extends StatelessWidget {
  final GlobalState state;

  const LoadingScreen({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavHeader(state: state),
        Expanded(
            child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ))
      ],
    );
  }
}
