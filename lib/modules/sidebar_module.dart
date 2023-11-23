import 'package:flutter/material.dart';

class SidebarModule extends StatelessWidget {
  const SidebarModule({super.key, required this.widgets});

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widgets,
    );
  }
}
