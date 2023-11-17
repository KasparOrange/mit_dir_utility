import 'package:flutter/material.dart';

abstract class SidebarActionsInterface {
  List<Widget> get sidebarActions;
}

// class SidebarActionsNotifier extends ChangeNotifier {
//   List<Widget> _sidebarActions = [];

//   List<Widget> get sidebarActions => _sidebarActions;

//   setSidebarActions(List<Widget> actions) {
//     _sidebarActions = actions;
//     notifyListeners();
//   }
// }
