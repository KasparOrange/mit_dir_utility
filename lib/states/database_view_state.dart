import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';

class DatabaseViewState extends ChangeNotifier {
  
  // NOTIPROP: searchPhrase
  String? _searchPhrase;
  String? get searchPhrase => _searchPhrase;
  set searchPhrase(String? value) {
    _searchPhrase = value;
    notifyListeners();
  }

  // NOTIPROP: users
  List<UserModel>? _users;
  List<UserModel>? get users => _users;
  set users(List<UserModel>? value) {
    _users = value;
    notifyListeners();
  }
  
  // NOTIPROP: filteredUsers
  List<UserModel>? _filteredUsers;
  List<UserModel>? get filteredUsers => _filteredUsers;
  set filteredUsers(List<UserModel>? value) {
    _filteredUsers = value;
    notifyListeners();
  }

}
