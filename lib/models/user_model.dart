import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class UserModel {
  DateTime timeOfCreation;
  DateTime dateOfBirth;
  String email;
  String firstName;
  String lastName;
  late DateTime lastUpdate;
  String nickName;
  String note;
  String phone;
  String uid;

  final String defaultStringValue = 'EMPTY';

  UserModel({
    required this.timeOfCreation,
    required this.firstName,
    required this.lastName,
    required this.uid,
    required this.dateOfBirth,
    required this.email,
    required this.nickName,
    required this.note,
    required this.phone,
  }) {
    lastUpdate = DateTime.now().toUtc();
  }

  UserModel.incomplete(
      {required this.firstName,
      required this.lastName,
      required this.uid,
      DateTime? timeOfCreation,
      DateTime? dateOfBirth,
      String? email,
      String? nickName,
      String? note,
      String? phone})
      : this.dateOfBirth = dateOfBirth ?? DateTime.utc(1900, 1, 1),
        this.email = email ?? 'EMPTY',
        this.nickName = nickName ?? 'EMPTY',
        this.note = note ?? 'EMPTY',
        this.phone = phone ?? 'EMPTY',
        this.timeOfCreation = timeOfCreation ??
            DateTime.now()
                .toUtc(); // NOTE: If no creationTime is provided we assume the user is new and assign now to this field.

  ///
  /// Use this to convert users from Firestore to UserModels.
  ///
  UserModel.fromMap({required Map<String, dynamic> map})
      : this(
          timeOfCreation: (map['timeOfCreation'] as Timestamp).toDate(),
          dateOfBirth: (map['timeOfBirth'] as Timestamp).toDate(),
          // timeOfCreation: DateTime.parse(map['timeOfCreation']).toUtc(),
          // dateOfBirth: DateTime.parse(map['dateOfBirth']).toUtc(),
          email: map['email'],
          firstName: map['firstName'],
          lastName: map['lastName'],
          nickName: map['nickName'],
          uid: map['uid'],
          note: map['note'],
          phone: map['phone'],
        );


    ///
    /// Use this to convert imported data from a CSV to a UserModel. 
    ///
    UserModel.fromList({required List<String> list})
      : this(
          timeOfCreation: DateTime.parse(list[4]).toUtc(),
          dateOfBirth: DateTime.parse(list[6]).toUtc(),
          email: list[3],
          firstName: list[1],
          lastName: list[2],
          nickName: list[7],
          uid: list[0],
          note: list[8],
          phone: list[9],
        );

  UserModel.empty()
      : this(
          timeOfCreation: DateTime.now().toUtc(),
          dateOfBirth: DateTime.utc(1900, 1, 1),
          email: 'EMPTY',
          firstName: 'EMPTY',
          lastName: 'EMPTY',
          nickName: 'EMPTY',
          uid: 'EMPTY',
          note: 'EMPTY',
          phone: 'EMPTY',
        );

  Map<String, dynamic> get asMap {
    return {
      'timeOfCreation': timeOfCreation,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'lastUpdate': lastUpdate,
      'nickName': nickName,
      'note': note,
      'phone': phone,
      'uid': uid,
    };
  }
}
