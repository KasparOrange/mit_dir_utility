import 'package:flutter/material.dart';

class DatabaseViewState extends ChangeNotifier {
  
  // NOTIPROP: searchPhrase
  String? _searchPhrase;
  String? get searchPhrase => _searchPhrase;
  set searchPhrase(String? value) {
    _searchPhrase = value;
    notifyListeners();
  }
}
