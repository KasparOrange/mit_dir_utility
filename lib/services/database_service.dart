import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mit_dir_utility/models/user_model.dart';

class DatabaseService {
  static FirebaseFirestore get ffi => FirebaseFirestore.instance;
  static FirebaseStorage get fsi => FirebaseStorage.instance;

  /// Retrurn the donwload URL of the Signature.
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