import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';

class KeyboardService {
  static final textInputFocusNode = FocusNode(debugLabel: 'Text Input');

  /// The key to use for all hotkeys. Mainly to swtich between Ctrl and Shift
  static const modalKey = PhysicalKeyboardKey.shiftLeft;

  static keyHandler({
    required KeyEvent event,
    required BuildContext context,
  }) {
    if (textInputFocusNode.hasFocus ||
        event is! KeyDownEvent ||
        !HardwareKeyboard.instance.physicalKeysPressed.contains(modalKey)) return;

    switch (event.physicalKey) {
      case PhysicalKeyboardKey.keyJ:
        RoutingService.navigateLeft();
        break;

      case PhysicalKeyboardKey.keyK:
        RoutingService.navigateRight();
        break;

      case PhysicalKeyboardKey.keyP:
        AuthenticationService.fastSignInSignOut(context);
      default:
    }
  }
}
