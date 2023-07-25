
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingModule extends StatelessWidget {
  const LoadingModule({super.key}) : fullScreen = false;
  const LoadingModule.fullScreen({super.key}) : fullScreen = true;

  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    if (fullScreen) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
      return SpinKitPulse(
          size: height > width ? height : width,
          itemBuilder: (context, index) {
            return Image.asset('assets/images/logo_brown.png');
          },
          duration: const Duration(seconds: 2));
    } else {
      return SpinKitPulse(
          itemBuilder: (context, index) {
            return Image.asset('assets/images/logo_brown.png');
          },
          duration: const Duration(seconds: 2));
    }
  }
}
