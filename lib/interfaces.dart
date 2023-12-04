import 'package:flutter/material.dart';

abstract class SidebarInterface {
  List<Widget> get sidebarWidgets;
}

// class SidebarActionsNotifier extends ChangeNotifier {
//   List<Widget> _sidebarActions = [];

//   List<Widget> get sidebarActions => _sidebarActions;

//   setSidebarActions(List<Widget> actions) {
//     _sidebarActions = actions;
//     notifyListeners();
//   }
// }
