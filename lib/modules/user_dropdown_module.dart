import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class UserDropdownModule extends StatelessWidget {
  const UserDropdownModule({super.key, required this.user});

  final UserModel user;

  Widget _createDeleteDialog(BuildContext context, UserModel user) {
    return Center(
      child: Container(
        width: 500,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withAlpha(240),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'Are you sure you want to delete the user: ${user.firstName} ${user.lastName} with the UID: ${user.uid}?',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                      DatabaseService.deletePersonInFBFirestore(uid: user.uid);
                    },
                    child: const Text('DELETE')),
              ),
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    child: const Text('Back')),
              ),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: ElevatedButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                }
                showDialog(
                    context: context,
                    builder: (context) {
                      return Material(child: UserEditorModule(user: user));
                    });
              },
              child: const Center(child: Text('Edit'))),
        ),
        PopupMenuItem(
          value: 1,
          child: ElevatedButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return _createDeleteDialog(context, user);
                    });
              },
              child: const Center(child: Text('Delete'))),
        ),
      ],
      onSelected: (value) {
        // handle your functionality here
        GoRouter.of(context).pop();
        print('Clicked on Button: $value');
      },
      elevation: 5,
      shape: Border.all(),
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(width: 2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)),
          child: const Text('Options')),
    );
  }
}
