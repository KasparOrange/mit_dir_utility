import 'package:flutter/foundation.dart';

class RuntimeLoggingService with ChangeNotifier {
  final Map<DateTime, String> logList = {};

  void appendLog(String log) {
    logList[DateTime.now()] = log;
    notifyListeners();
  }
}