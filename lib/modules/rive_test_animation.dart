import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveTestAnimation extends StatelessWidget {
  const RiveTestAnimation({super.key}) : fullScreen = false;
  const RiveTestAnimation.fullScreen({super.key}) : fullScreen = true;

  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    if (fullScreen) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
        return const RiveAnimation.asset('animations/tryoutWithJanga.riv', alignment: Alignment.centerLeft,);
    } else {
      return const Expanded(child: RiveAnimation.asset('animations/mitdirlogobounce.riv'));
    }
  }
}
