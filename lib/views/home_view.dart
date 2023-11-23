import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';

class HomeView extends StatelessWidget implements SidebarActionsInterface{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('HomeView'),);
  }
  
  @override
  // TODO: implement sidebarActions
  List<Widget> get sidebarActions => [
    const Text("HomeView Sidebar"),
    const TextField(),
    ];
}