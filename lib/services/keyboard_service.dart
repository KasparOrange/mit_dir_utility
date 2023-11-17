import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
// import 'package:mit_dir_utility/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';

class KeyboardService {
  final textInputFocusNode = FocusNode(debugLabel: 'Text Input');

  // final _routeService = RoutingService();

  bool keyHandler({
    required KeyEvent event,
    required BuildContext context,
    // required ThemeService themeService
  }) {
    if (textInputFocusNode.hasFocus || event is! KeyDownEvent) return false;
    bool returnValue = false;
    if (_handelKeyboardRouting(context: context, event: event)) {
      returnValue = true;
    }
    if (_handleDrawerInteractions(context: context, event: event)) {
      returnValue = true;
    }
    // _handelKeyboardRouting(context: context, event: event);

    // if (_handleThemeToggle(event: event, themeService: themeService)) {
    //   returnValue = true;
    // }

    return returnValue;
  }

  // bool _handleThemeToggle(
  //     {required KeyEvent event, required ThemeService themeService}) {
  //   if (!HardwareKeyboard.instance.physicalKeysPressed
  //       .contains(PhysicalKeyboardKey.controlLeft)) return false;
  //   if (event.physicalKey == PhysicalKeyboardKey.keyQ) {
  //     // final themeService = Provider.of<ThemeService>(context);
  //     themeService.toggleThemeMode();
  //     return true;
  //   }
  //   return false;
  // }

  bool _handelKeyboardRouting({required KeyEvent event, required BuildContext context}) {
    if (!HardwareKeyboard.instance.physicalKeysPressed.contains(PhysicalKeyboardKey.shiftLeft)) {
      return false;
    }

    final _routingService = Provider.of<RoutingService>(context, listen: false);

    // final currentRouteIndex = _routeService.routePaths.indexOf(GoRouter.of(context).location);
    final currentRouteIndex = _routingService
        .routeBuilders
        .keys
        .toList()
        .indexOf(GoRouter.of(context).location);

    if (event.physicalKey == PhysicalKeyboardKey.keyJ) {
      final leftRouteIndex = currentRouteIndex - 1;

      if (leftRouteIndex > -1) {
        // context.go(_routeService.routePaths[leftRouteIndex]);
        context
            .go(_routingService.routeBuilders.keys.toList()[leftRouteIndex]);
        return true;
      }
    } else if (event.physicalKey == PhysicalKeyboardKey.keyK) {
      final rightRouteIndex = currentRouteIndex + 1;

      if (rightRouteIndex < _routingService.routeBuilders.length) {
        // context.go(_routeService.routePaths[rightRouteIndex]);
        context
            .go(_routingService.routeBuilders.keys.toList()[rightRouteIndex]);
        return true;
      }
      // if (rightRouteIndex < _routeService.routePaths.length) {
      //   context.go(_routeService.routePaths[rightRouteIndex]);
      //   return true;
      // }
    }
    return false;
  }

  bool _handleDrawerInteractions({required KeyEvent event, required BuildContext context}) {
    if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      try {
        Scaffold.of(context).openDrawer();
      } catch (e) {
        log('Tryed to open drawer $e');
      }

      return true;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      Scaffold.of(context).openEndDrawer();
      return true;
    }
    return false;
  }
}
