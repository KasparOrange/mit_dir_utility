import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class UserModel {
  DateTime creationTime;
  DateTime dateOfBirth;
  String email;
  String firstName;
  String lastName;
  DateTime lastUpdate = DateTime.now().toUtc();
  String nickName;
  String note;
  String phone;
  String uid;

  final String defaultStringValue = 'EMPTY';

  UserModel({
    required this.creationTime,
    required this.firstName,
    required this.lastName,
    required this.uid,
    required this.dateOfBirth,
    required this.email,
    required this.nickName,
    required this.note,
    required this.phone,
  });

  UserModel.incomplete(
      {required this.firstName,
      required this.lastName,
      required this.uid,
      DateTime? creationTime,
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
        this.creationTime = creationTime ??
            DateTime.now()
                .toUtc(); // NOTE: If no creationTime is provided we assume the user is new and assign now to this field.


  UserModel.fromMap({required Map<String, dynamic> map})
      : this(
          creationTime: (map['creationTime'] as Timestamp).toDate(),
          dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
          email: map['email'],
          firstName: map['firstName'],
          lastName: map['lastName'],
          nickName: map['nickName'],
          uid: map['uid'],
          note: map['note'],
          phone: map['phone'],
        );

    UserModel.empty()
      : this(
          creationTime: DateTime.now().toUtc(),
          dateOfBirth: DateTime.utc(1900, 1, 1),
          email: 'EMPTY',
          firstName: 'EMPTY',
          lastName: 'EMPTY',
          nickName: 'EMPTY',
          uid:'EMPTY',
          note: 'EMPTY',
          phone: 'EMPTY',
        );

  Map<String, dynamic> get asMap {
    return {
      'creationTime': creationTime,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'note': note,
      'phone': phone,
      'uid': uid,
    };
  }
}
