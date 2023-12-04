import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mit_dir_utility/globals.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/signature_button_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class UserListTileModule extends StatelessWidget {
  const UserListTileModule({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text('${user.firstName}  ${user.lastName}'),
        subtitle: Text('${user.email}'),
        trailing: SignatureButtonModule(isSigned: Random().nextBool(),),
        // IconButton(
        //   icon: Image.asset('icons/icons8-signature-50.png'),
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         title: const Text('Delete User'),
        //         content: Text('Do you really want to delete ${user.firstName} ${user.lastName}?'),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //             child: const Text('Cancel'),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               // DatabaseService.deleteUser(user);
        //               Navigator.of(context).pop();
        //             },
        //             child: const Text('Delete'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}