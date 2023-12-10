import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mit_dir_utility/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/keyboard_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/network_status_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';
import 'package:mit_dir_utility/states/database_view_state.dart';
import 'package:mit_dir_utility/states/sidebar_state.dart';
import 'package:provider/provider.dart';

void main() async {
  // Prevent the default right-click menu in the entire app
  js_util.callMethod(html.window, 'addEventListener', [
    'contextmenu',
    js_util.allowInterop((html.Event event) {
      event.preventDefault();
    })
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set the firebase setting with persistence enabled
  // TODO: Set the size for the cache
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routingService = RoutingService();
  final _keyboardService = KeyboardService();
  // final _themeService = ThemeService();
  // final _databaseService = DatabaseService();
  final _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthenticationService().user,
          initialData: null,
        ),
        Provider.value(value: _routingService),
        Provider.value(value: _keyboardService),
        Provider.value(value: _authService),
        ChangeNotifierProvider(create: (context) => RuntimeLoggingService()),
        ChangeNotifierProvider(create: (context) => SidebarState()),
        ChangeNotifierProvider(create: (context) => DatabaseViewState()),
        ChangeNotifierProvider(create: (context) => NetworkStatusService()),
      ],
      child: Builder(builder: (context) {
        log('Building MaterialApp', onlyDebug: true);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _routingService.router,
          title: 'MitWare',
          theme: ThemeService.mainTheme,
        );
      }),
    );
  }
}
