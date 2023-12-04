import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/states/sidebar_state.dart';
import 'package:provider/provider.dart';

class TimetableView extends StatelessWidget implements SidebarInterface {
  const TimetableView({super.key});

  @override
  List<Widget> get sidebarWidgets {
    return [
      const Text("TimetableView Sidebar"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SidebarState>(context, listen: false).widgets = sidebarWidgets;
    });
    return const Placeholder();
  }
}
