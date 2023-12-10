import 'package:flutter/widgets.dart';

class SidebarState extends ChangeNotifier {
  // NOTIPROP: widgets
  List<Widget> _widgets = [];
  List<Widget> get widgets => _widgets;
  set widgets(List<Widget> value) {
    _widgets = value;    
    notifyListeners();
  }
}
