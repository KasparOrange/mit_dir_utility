import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
import 'package:provider/provider.dart';
import 'package:validation_pro/validate.dart';
import 'package:mit_dir_utility/services/logging_service.dart';

class AuthenticationService {
  // NOTE: Initially a sign-in view should be shown.
  AuthViewToShow authViewToShow = AuthViewToShow.ShowSignIn;
  static String email = 'ko.fcbu@gmail.com';
  static String password = 'MITDIRORGA!2022';

  static FirebaseAuth fai = FirebaseAuth.instance;

  Stream<User?> get user {
    return FirebaseAuth.instance.authStateChanges();
  }

  static fastSignInSignOut(BuildContext context) async {
    Provider.of<User?>(context, listen: false) == null
        ? await signInWithEmailAndPassword(email, password)
        : await signOut();
  }

  Future signInAnonymously() async {
    try {
      final userCredential = await fai.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      log(e);
      return null;
    }
  }

  static Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    } catch (e) {
      log(e);
      return null;
    }
  }

  /// This will first create the user in the authorization and then in the database.
  Future<void> createUser(String email, String password) async {
    try {
      UserCredential userCredential = await fai.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DatabaseService.createUserInDatabase(user: userCredential.user!);

      String uid = userCredential.user!.uid;

      await firestore.collection('users').doc(uid).set(additionalUserInfo);

    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future createUserInFBAuthorization(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // NOTE: Create a new document for the user with the uid.
      // await DatabaseService.createUserInDatabase(user: userCredential.user!);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e);
      return null;
    }
  }

  static Future signOut() async {
    try {
      print('Signing out');
      RoutingService.navigateTo('/');
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      log(e);
      return null;
    }
  }

  static String? validateEmail(value) {
    return Validate.isEmail(value)
        ? null
        : """
              Bitte gib eine gültige E-Mail Adresse an.
          """;
  }

  static String? validatePassword(value) {
    return Validate.isPassword(value)
        ? null
        : """
              Das Passwort muss zwischen 6 und 12 Zeichen lang sein und 
              mindestens jeweils einen Großbuchstaben, einen kleinen Buchstaben, 
              eine Ziffer und ein Sonderzeichen enthalten.
          """;
  }

  static bool checkUserRightsLevel({required UserRightsLevel needs, required UserRightsLevel has}) {
    return needs.index < has.index;
  }
}

enum UserRightsLevel {
  Random,
  Guest,
  Member,
  Moderator,
  Admin,
}

enum AuthViewToShow { ShowRegister, ShowSignIn, ShowSignOut }

enum Move {
  up,
  down,
  left,
  right;

  Offset get offset => switch (this) {
        up => const Offset(0.0, 1.0),
        down => const Offset(0.0, -1.0),
        left => const Offset(-1.0, 0.0),
        right => const Offset(1.0, 0.0),
      };
}
