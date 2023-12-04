import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';

class HomeView extends StatelessWidget implements SidebarInterface {
  const HomeView({super.key});

  @override
  List<Widget> get sidebarWidgets => [];

  @override
  Widget build(BuildContext context) {
    print('Building HomeView');
    return const Center(
      child: Text('HomeView'),
    );
  }
}
