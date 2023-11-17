import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/loading_module.dart';
import 'package:mit_dir_utility/modules/signature_list_entry_module.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/modules/user_list_tile_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/filesystem_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class DatabaseView extends StatefulWidget implements SidebarActionsInterface {
  const DatabaseView({super.key});

  @override
  State<DatabaseView> createState() => _DatabaseViewState();

  @override
  // TODO: implement sidebarActions
  List<Widget> get sidebarActions => [];
}

class _DatabaseViewState extends State<DatabaseView> {
  List<UserModel> users = []; // Local state to store users
  List<UserModel> filteredUsers = [];

  List<Widget> get sidebarActions {
    return [
      Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Material(child: UserEditorModule(user: UserModel.empty()));
                });
          },
          child: const Text('Add Person'),
        );
      }),
      Builder(builder: (context) {
        return const ElevatedButton(
          onPressed: FilesystemService.pickFile,
          child: Text('Import CSV'),
        );
      }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            searchUsers(searchQuery);
          },
          decoration: const InputDecoration(
            labelText: 'Search',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
    ];
  }

  String searchQuery = '';

  void searchUsers(String query) {
    if (query.isEmpty) {
      // If the search field is empty, display all users
      setState(() => filteredUsers = users);
    } else {
      // Filter the users list based on the search query
      var lowercaseQuery = query.toLowerCase();
      var newFilteredUsers = users.where((user) {
        return user.firstName.toLowerCase().contains(lowercaseQuery) ||
            user.lastName.toLowerCase().contains(lowercaseQuery) ||
            user.email.toLowerCase().contains(lowercaseQuery) ||
            user.phone.toLowerCase().contains(lowercaseQuery) ||
            user.note.toLowerCase().contains(lowercaseQuery) ||
            user.nickName.toLowerCase().contains(lowercaseQuery);
      }).toList();
      setState(() => filteredUsers = newFilteredUsers);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<SidebarActionsNotifier>(context, listen: false)
    //     .setSidebarActions(sidebarActions);

    return Row(children: [
      Container(
        color: Colors.green,
        width: 250,
        child: Column(children: [
          const Text('Sidebar'),
          ...sidebarActions,
        ]),
      ),
      Expanded(
        child: StreamBuilder(
          stream: DatabaseService.userStream,
          builder: (context, snapshot) {
            // print("Data: ${snapshot.data}");
            // print("Error: ${snapshot.error}");
            // print("Connection State: ${snapshot.connectionState}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No users found'));
            }

            users = snapshot.data!;

            if (filteredUsers.isEmpty && searchQuery.isEmpty) {
              filteredUsers = users;
            }

            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                // Build user list item widget
                return UserListTileModule(user: filteredUsers[index]);
              },
            );
          },
        ),
      ),
    ]);
  }
}
