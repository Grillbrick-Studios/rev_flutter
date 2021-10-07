import 'package:flutter/cupertino.dart';
import 'package:rev_flutter/src/settings/global_state.dart';

class AppendixView extends StatelessWidget {
  static const routeName = '/resources/appendix';
  final GlobalState state;

  const AppendixView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //   if (state.appendix == null) return const LoadingScreen();
    //   final appendix = state.appendix!;
    //   return Html(data: appendix.getAppendix(state.book!));
    throw UnimplementedError();
  }
}
