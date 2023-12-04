import 'package:flutter/material.dart';
import 'package:mit_dir_utility/globals.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/signature_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';

class UserListTileModule extends StatefulWidget {
  const UserListTileModule({super.key, required this.user});

  final UserModel user;

  @override
  State<UserListTileModule> createState() => _UserListTileModuleState();
}

class _UserListTileModuleState extends State<UserListTileModule> {
  updateUserListTileModule() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text('${widget.user.firstName}  ${widget.user.lastName}'),
        subtitle: Text(widget.user.email),
        trailing: FutureBuilder(
            future: DatabaseService.doesSignatureExist(widget.user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                log(snapshot.error!, onlyDebug: false, long: true);
                return const Icon(Icons.error);
              }
              return SignatureModule(user: widget.user);
            }),
      ),
    );
  }
}
