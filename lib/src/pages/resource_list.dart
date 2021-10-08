import 'package:flutter/material.dart';

import '../modules/nav_header.dart';
import '../settings/boxes.dart';

/// A page to show all resources
class ResourceList extends StatelessWidget {
  static const routeName = '/resources';

  const ResourceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const NavHeader(),
          ...Resource.values
              .map((e) => TextButton(
                    // onPressed: () => state.updateResource(e),
                    onPressed: () => Boxes.resource = e,
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
