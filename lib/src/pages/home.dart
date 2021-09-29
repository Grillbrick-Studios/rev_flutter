import 'package:flutter/material.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

import '../models/bible.dart';

/// A simple Widget that presents a hello world screen.
class HelloWorld extends StatefulWidget {
  const HelloWorld({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  Bible? bible;

  @override
  Widget build(BuildContext context) {
    if (bible != null) {
      return ListView(
        children: bible!.listBooks
            .map((b) => Text(
                  b,
                  style: Theme.of(context).textTheme.headline1,
                ))
            .toList(),
      );
    } else {
      Bible.load().then((b) => setState(() {
            bible = b;
          }));
      return Center(
        child: Text(
          'Loading Data...',
          style: Theme.of(context).textTheme.headline1,
        ),
      );
    }
  }
}

class Home extends StatelessWidget {
  static const routeName = '/';
  final GlobalState state;

  const Home({Key? key, required this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Welcome Home!'));
  }
}
