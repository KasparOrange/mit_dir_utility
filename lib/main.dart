import 'package:firebase_core/firebase_core.dart';
import 'package:mit_dir_utility/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/views/home_view.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 124, 3)),
      ),
      home: const Scaffold(
          // floatingActionButton: Text('Version 0.0.1'),

          // floatingActionButton: FloatingActionButton.small(
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return const Text('Version: 0.0.1');
          //         });
          //     // showAboutDialog(context: context, applicationVersion: '0.0.1');
          //   },
          //   child: const Icon(Icons.info_outline),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
          body: HomeView()),
    );
  }
}
