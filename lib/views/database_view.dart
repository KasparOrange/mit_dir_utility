import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/loading_module.dart';
import 'package:mit_dir_utility/modules/signature_list_entry_module.dart';
import 'package:mit_dir_utility/modules/user_dropdown_module.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';

class DatabaseView extends StatelessWidget {
  const DatabaseView({super.key});

  Widget _tableCellSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget _tableCellTitle(String title) {
    return Text(
      '$title: ',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _tableCellEntry(String entry, double width) {
    return SizedBox(width: width, child: Text(entry));
  }

  Widget _tableCellName(String firstName, String lastName) {
    return SizedBox(
      width: 150,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$firstName $lastName',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(screenSize),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('people').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red[900]),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingModule.fullScreen();
            }

            return Column(children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.7),
                child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return  
                  ListTile(
                      shape: const Border.symmetric(horizontal: BorderSide()),
                      leading: _tableCellName(data['firstName'], data['lastName']),
                      title: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _tableCellTitle('Email'),
                                _tableCellEntry(data['email'], 200),
                                _tableCellSpace(10),
                                _tableCellTitle('Phone'),
                                _tableCellEntry(data['phone'], 200),
                                _tableCellSpace(10),
                                _tableCellTitle('Date of Birth'),
                                _tableCellEntry(
                                    (data['dateOfBirth'] as Timestamp)
                                        .toDate()
                                        .format(EuropeanDateFormats.shortHyphenated),
                                    100),
                                _tableCellSpace(10),
                                SizedBox(
                                  width: 20,
                                  child: FutureBuilder(
                                      future: DatabaseService.checkSignatureExsistsInFBStorage(
                                          data['uid']),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(snapshot.error.toString());
                                        }
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const LoadingModule();
                                        }
                                        return SignatureListEntryModule(
                                            signatureExists: snapshot.data!);
                                      }),
                                ),
                                _tableCellSpace(10),
                                _tableCellTitle('Creation Time'),
                                _tableCellEntry(
                                    (data['creationTime'] as Timestamp).toDate().format(), 100),
                                _tableCellSpace(10),
                                _tableCellTitle('Last Update'),
                                _tableCellEntry(
                                    (data['lastUpdate'] as Timestamp).toDate().format(), 100)
                              ],
                            ),
                          )),
                      // subtitle: Text('UID: ${data['uid']}'),
                      trailing: UserDropdownModule(user: UserModel.fromMap(map: data)));
                }).toList()),
              ),
              ElevatedButton(
                child: const Text('Add Person'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Material(child: UserEditorModule(user: UserModel.empty()));
                      });
                  Provider.of<RuntimeLoggingService>(context, listen: false).appendLog('Test');
                  // final user = UserModel.incomplete(
                  //     firstName: 'Tom',
                  //     lastName: 'Tester',
                  //     uid: (Random().nextInt(9000) + 1000).toString());
                  // await DatabaseService.createPersonInFBFirestore(user: user);
                },
              )
            ]);
          }),
    );
  }
}
