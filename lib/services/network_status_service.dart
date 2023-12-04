import 'dart:html' as html;

class NetworkStatusService {
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

  static bool? get isOnline => html.window.navigator.onLine;

  static void startListening(Function onGoingOnline, Function onGoingOffline) {
    html.window.addEventListener('online', (event) {
      onGoingOnline();
      print('Back online');
    });

    html.window.addEventListener('offline', (event) {
      onGoingOffline();
      print('Went offline');
    });
  }
}
