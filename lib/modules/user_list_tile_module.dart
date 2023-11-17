import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';

class UserListTileModule extends StatelessWidget {
  const UserListTileModule({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${user.firstName}  ${user.lastName}'),
    );
  }
}