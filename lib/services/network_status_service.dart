import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/logging_service.dart';

class NetworkStatusService with ChangeNotifier {
  NetworkStatusService() {
    startListening(onGoingOnline: () {
      isOnline = true;
    }, onGoingOffline: () {
      isOnline = false;
    });
  }
  static int? get networkSpeed => html.window.navigator.connection?.downlink?.round();

  static int get networkType {
    final type = html.window.navigator.connection?.effectiveType;
    if (type == 'slow-2g') {
      return 0;
    } else if (type == '2g') {
      return 1;
    } else if (type == '3g') {
      return 2;
    } else if (type == '4g') {
      return 3;
    } else if (type == '5g') {
      return 4;
    } else {
      return 5;
    }
  }

  static int secondsSinceLastConnection = 0;

  static bool? get isOnlineGetter => html.window.navigator.onLine;

  // NOTIPROP: isOnlin
  bool _isOnline = isOnlineGetter ?? false;
  bool get isOnline => _isOnline;
  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void startListening({Function? onGoingOnline, Function? onGoingOffline}) {
    html.window.addEventListener('online', (event) {
      onGoingOnline?.call();
      print('Back online');
    });

    html.window.addEventListener('offline', (event) {
      onGoingOffline?.call();
      print('Went offline');
    });
  }
}
