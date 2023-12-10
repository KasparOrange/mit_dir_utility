import 'package:flutter/material.dart';

class BackgroundLogoModule extends StatelessWidget {
  const BackgroundLogoModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/logo_brown.png'),
              opacity: 0.2,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter),
          gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          backgroundBlendMode: BlendMode.darken),
    );
  }
}
