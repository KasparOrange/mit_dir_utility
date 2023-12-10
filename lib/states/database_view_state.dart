import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class DatabaseViewState extends ChangeNotifier {
  
  // NOTE: This is the mauual way of doing it
  // StreamSubscription<List<UserModel>>? _userSubscription;
  // DatabaseViewState() {
  //   _userSubscription = DatabaseService.userStream.listen((users) {
  //     _users = users;
  //     notifyListeners();
  //   });
  // }
  // @override
  // void dispose() {
  //   _userSubscription?.cancel();
  //   super.dispose();
  // }
  // NOTE: Manual out

  // NOTIPROP: searchPhrase
  String _searchPhrase = '';
  String get searchPhrase => _searchPhrase;
  set searchPhrase(String value) {
    _searchPhrase = value;
    notifyListeners();
  }

  // NOTIPROP: users
  List<UserModel> _users = [];
  List<UserModel> get users => _users;
  set users(List<UserModel> value) {
    _users = value;
    // notifyListeners();
  }

  // NOTIPROP: filteredUsers
  List<UserModel> _filteredUsers = [];
  List<UserModel> get filteredUsers => _filteredUsers;
  set filteredUsers(List<UserModel> value) {
    _filteredUsers = value;
    notifyListeners();
  }

  // NOTIPROP: totalUserAmount
  int _totalUserAmount = 0;
  int get totalUserAmount => _totalUserAmount;
  set totalUserAmount(int value) {
    _totalUserAmount = value;
    notifyListeners();
  }

  // NOTIPROP: filteredUserAmount
  int _filteredUserAmount = 0;
  int get filteredUserAmount => _filteredUserAmount;
  set filteredUserAmount(int value) {
    _filteredUserAmount = value;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }
}
