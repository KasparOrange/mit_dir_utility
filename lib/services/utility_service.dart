import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UtilityService {
  static void clickRenderObjectProgrammatically(
      {required GlobalKey globalKey, int delayInMilliseconds = 0}) async {
    final renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(Offset.zero);

    // NOTE: If the click should be just in the middle of the screen.
    // final position = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);

    GestureBinding.instance.handlePointerEvent(PointerDownEvent(position: position));

    if (delayInMilliseconds > 0) {
      await Future.delayed(Duration(milliseconds: delayInMilliseconds));
    }

    GestureBinding.instance.handlePointerEvent(PointerUpEvent(position: position));
  }


  // NOTE: For testing loading animations.
  // Future _fakeLoading() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   return await Future.delayed(const Duration(seconds: 3)).then((_) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }
}