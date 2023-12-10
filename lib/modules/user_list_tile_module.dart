import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/signature_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';

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
      color: ThemeService.colors.oldPrimaryColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 300,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.user.firstName} ${widget.user.lastName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        title: Text('Date of birth: ${widget.user.dateOfBirth.format('F j, Y')}'),
        subtitle: Text('Contact: ${widget.user.email} ${widget.user.phone}'),
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
