import 'package:flutter/material.dart';

import '../modules/nav_header.dart';
import '../settings/global_state.dart';
import '../settings/stored_state.dart';

/// A page to show all resources
class ResourceList extends StatelessWidget {
  static const routeName = '/resources';
  final GlobalState state;

  const ResourceList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          NavHeader(state: state),
          ...Resource.values
              .map((e) => TextButton(
                    onPressed: () => state.updateResource(e),
                    child: Text(
                      e.asString,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ))
              .toList(),
          // This adds some scroll past stuff
          tail,
        ],
      ),
    );
  }
}
