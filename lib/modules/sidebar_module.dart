import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';
import 'package:mit_dir_utility/states/sidebar_state.dart';
import 'package:provider/provider.dart';

class SidebarModule extends StatefulWidget {
  const SidebarModule({Key? key}) : super(key: key);

  @override
  State<SidebarModule> createState() => _SidebarModuleState();
}

class _SidebarModuleState extends State<SidebarModule> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  List<Widget> intersperseSpacer(List<Widget> widgets, double space) {
    // Create an empty list to store the widgets with spacers
    List<Widget> interspersed = [];

    // Iterate over the original list and add a Spacer after each widget
    for (var i = 0; i < widgets.length; i++) {
      if (i < widgets.length - 1) {
        // Add a Spacer after the widget, except for the last widget
        interspersed.add(SizedBox(height: space));
      }

      interspersed.add(widgets[i]); // Add the original widget
    }

    return interspersed;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = Provider.of<SidebarState>(context, listen: true).widgets;
    _restartAnimation(); // Restart animation on each build

    log('SidebarModule build', onlyDebug: true);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: ThemeService.colors.newBackground,
        gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _offsetAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: _offsetAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: intersperseSpacer(widgets, 10),
            ),
          );
        },
      ),
    );
  }
}
