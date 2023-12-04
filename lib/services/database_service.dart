import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/services/logging_service.dart';

class DatabaseService {
  static FirebaseFirestore get ffi => FirebaseFirestore.instance;
  static FirebaseStorage get fsi => FirebaseStorage.instance;

  static bool mocking = true;
  static String get usersCollection => mocking ? 'mockUsers' : 'people';
  static String get signaturesBucket => mocking ? 'mockSignatures' : 'signatures';

  // NOTE: NEW!
  static Future<String> uploadSignature(UserModel user, Uint8List bytes) async {
    final ref = fsi.ref().child('$signaturesBucket/${user.uid}_signature.png');

    await ref.putData(bytes);

    return await ref.getDownloadURL();
  }

  
  /// Use to find out if a signature exists in the Firebase Storage.
  static Future<bool> doesSignatureExist(UserModel user) async {
    try {
      final ref = fsi.ref().child('$signaturesBucket/${user.uid}_signature.png');

      await ref.getMetadata();

      return true; // File exists
    } catch (e) {
      log('ERRROR while checking signature: $e', long: true, onlyDebug: true);
      return false; // File does not exist
    }
  }

  // Donwload signature
  static Future<Uint8List?> downloadSignature(UserModel user) async {
    try {
      final ref = fsi.ref().child('$signaturesBucket/${user.uid}_signature.png');

      return await ref.getData();
    } on FirebaseException catch (e) {
      log('ERRROR while downloading signature: $e', long: true);
      return null;
    }
  }

  // Delete signature
  static Future<void> deleteSignature(UserModel user) async {
    try {
      final ref = fsi.ref().child('$signaturesBucket/${user.uid}_signature.png');

      await ref.delete();
    } on FirebaseException catch (e) {
      log('ERRROR while deleting signature: $e', long: true);
    }
  }

  // NOTE: OLD!
  /// Return the donwload URL of the Signature.
  static Future<String> uploadSignatureToFBStorage(String name, Uint8List bytes) async {
    final randomNumber = Random().nextInt(9000) + 1000; // TODO: Change to Firebase Global ID.

    final ref =
        fsi.ref().child('images/${name.replaceAll(' ', '_')}_${randomNumber}_signature.png');

    await ref.putData(bytes);

    return await ref.getDownloadURL();
  }

  static Future<bool> checkSignatureExsistsInFBStorage(String uid) async {
    final ref = fsi.ref().child('images/${uid}_signature.png');
    try {
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future createPersonInFBFirestore({required UserModel user}) {
    return ffi.collection('people').doc(user.uid).set(user.asMap);
  }

  static Future deletePersonInFBFirestore({required String uid}) {
    return ffi.collection('people').doc(uid).delete();
  }

  static Future<UserModel> readPersonInFBFireStore({required String uid}) async {
    final snapshot = await ffi.collection('people').doc(uid).get();
    final data = snapshot.data();
    return UserModel.fromMap(map: data!);
  }

  static Future updatePersonInFBFireStore({required UserModel user}) async {
    final userDocument = await ffi.collection('people').doc(user.uid).get();
    if (userDocument.exists) {
      return await ffi.collection('people').doc(user.uid).set(user.asMap);
    } else {
      return Future.error('User does not exsist in FireStore database!');
    }
  }

  static Future createPersonInFBFireStore({required UserModel user}) async {
    return await ffi.collection('people').doc(user.uid).set(user.asMap);
  }

  static Future createMockUserInFBFireStore({required UserModel user}) async {
    return await ffi.collection('mockUsers').doc().set(user.asMap);
  }

  static Stream<List<UserModel>> get userStream =>
      ffi.collection(usersCollection).snapshots().map((snapshot) => snapshot.docs.map((doc) {
            // print(doc.data());
            return UserModel.fromMap(map: doc.data());
          }).toList());

  static Future<List<UserModel>> get users async {
    final snapshot = await ffi.collection(usersCollection).get();
    return snapshot.docs.map((doc) => UserModel.fromMap(map: doc.data())).toList();
  }

  //   Future _uploadImageToFBStorage(String name, Uint8List bytes) async {
  //   final randomNumber = Random().nextInt(9000) + 1000;

  //   final ref = FirebaseStorage.instance
  //       .ref()
  //       .child('images/${name.replaceAll(' ', '_')}_${randomNumber}_signature.png');

  //   String url = '';

  //   await Future.wait([
  //     Future.delayed(const Duration(seconds: 2)),
  //     ref.putData(bytes).then((_) async {
  //       await ref.getDownloadURL().then((value) {
  //         _copyToClipboard(value);
  //         url = value;
  //       });
  //     })
  //   ]).then((_) {
  //     setState(() {
  //       loading = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         onVisible: () {
  //           // _clickButtonProgrammatically();
  //           // Clipboard.setData(ClipboardData(text: url));
  //           _copyToClipboard(url);
  //         },
  //         backgroundColor: Theme.of(context).colorScheme.primary,
  //         behavior: SnackBarBehavior.floating,
  //         elevation: 50,
  //         duration: const Duration(days: 1),
  //         content: Center(
  //             child: Column(children: [
  //           Theme(
  //               data: Theme.of(context).copyWith(
  //                   textSelectionTheme: TextSelectionThemeData(
  //                       selectionColor: Theme.of(context).colorScheme.tertiary)),
  //               child: TextField(
  //                 controller: _selectionTextEditingController..text = url,
  //                 focusNode: _selectionFocusNode,
  //                 onTap: () {
  //                   FocusScope.of(context).requestFocus(_selectionFocusNode);
  //                 },
  //                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
  //               )),
  //           SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.8,
  //             width: MediaQuery.of(context).size.width * 0.8,
  //             child: TextButton(
  //               key: _buttonKey,
  //               onPressed: () {
  //                 // Clipboard.setData(ClipboardData(text: url));
  //                 _copyToClipboard(url);
  //                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //               },
  //               child: const Text(
  //                 'Copy to clipboard',
  //                 style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           )
  //         ]))));
  //   });
  // }
}
