import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/csv_importer_module.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/modules/user_list_tile_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/states/database_view_state.dart';
import 'package:provider/provider.dart';

class AccreditationView extends StatefulWidget implements SidebarInterface {
  const AccreditationView({super.key});

  @override
  State<AccreditationView> createState() => _AccreditationViewState();

  @override
  List<Widget> get sidebarWidgets {
    return [
      Builder(
        builder: (context) {
          return UserEditorModule(user: UserModel.empty());
        }
      ),
      const CSVImporterModule(),
      Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: (value) {
              var state = Provider.of<DatabaseViewState>(context, listen: false);
              state.filteredUsers = [];
              if (value.isEmpty) {
                // If the search field is empty, display all users
                state.filteredUsers = state.users;
                state.filteredUserAmount = state.users.length;
                log('Value was empty', long: true, onlyDebug: false);
              } else {
                // Filter the users list based on the search query
                var lowercaseQuery = value.toLowerCase();
                var newFilteredUsers = state.users
                    .where((user) =>
                        user.firstName.toLowerCase().contains(lowercaseQuery) ||
                        user.lastName.toLowerCase().contains(lowercaseQuery) ||
                        user.email.toLowerCase().contains(lowercaseQuery) ||
                        user.phone.toLowerCase().contains(lowercaseQuery) ||
                        user.note.toLowerCase().contains(lowercaseQuery) ||
                        user.nickName.toLowerCase().contains(lowercaseQuery))
                    .toList();
                state.filteredUsers = newFilteredUsers;
                state.filteredUserAmount = newFilteredUsers.length;
                log(newFilteredUsers.length, long: true, onlyDebug: true);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        );
      }),
      Builder(builder: (context) {
        return Text(
          'Total: ${Provider.of<DatabaseViewState>(context).totalUserAmount}'
          ' | Filtered: ${Provider.of<DatabaseViewState>(context).filteredUserAmount}',
          // style: const TextStyle(fontFamily: 'Willow')
        );
      }),
    ];
  }
}

class _AccreditationViewState extends State<AccreditationView> {
  bool initialized = false;

  update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<DatabaseViewState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder(
        stream: DatabaseService.userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget('An error occured! Are you signed in?\n${snapshot.error}');
          }

          state.users = snapshot.data!;

          // The first time the stream is loaded, set the filteredUsers to the users to
          // display all users. If this is not done, no users will be displayed until the
          // search field is used.
          if (!initialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              state.filteredUsers = state.users;
              state.totalUserAmount = state.users.length;
              state.filteredUserAmount = state.users.length;
            });
            initialized = true;
          }

          return ListView.builder(
            itemCount: state.filteredUsers.length,
            itemBuilder: (context, index) {
              return UserListTileModule(user: state.filteredUsers[index]);
            },
          );
        },
      ),
    );
  }
}
