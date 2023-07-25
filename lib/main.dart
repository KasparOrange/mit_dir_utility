import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mit_dir_utility/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/keyboard_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:mit_dir_utility/views/authentication_view.dart';
import 'package:mit_dir_utility/views/signing_view.dart';
import 'package:mit_dir_utility/views/drawer_view.dart';
import 'package:mit_dir_utility/views/runtime_logging_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await FirebaseAuth.instance.signInAnonymously();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

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
        // StreamProvider<QuerySnapshot?>.value(value: DatabaseService().posts, initialData: null),
        Provider.value(value: _routingService),
        Provider.value(value: _keyboardService),
        // Provider.value(value: _databaseService),
        Provider.value(value: _authService),
        // ListenableProvider.value(value: _themeService),
        ChangeNotifierProvider(create: (context) => RuntimeLoggingService()),
      ],
      child: Builder(builder: (context) {
        // final themeService = Provider.of<ThemeService>(context);
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _routingService.router,
            title: 'MitWare',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 124, 3)),
              // theme: themeService.lightTheme,
              // darkTheme: themeService.darkTheme,
              // themeMode: themeService.themeMode,
            ));
      }),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 124, 3)),
    //   ),
    //   routes: {
    //     '/': (context) => Scaffold(
    //         // drawer: DrawerView(),
    //         // appBar: AppBar(),

    //         floatingActionButton: FloatingActionButton.small(
    //           onPressed: () {
    //             print('sfsd');
    //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoggingView()));
    //           },
    //           child: const Icon(Icons.info_outline),
    //         ),
    //         floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    //         body: HomeView()),
    //     '/logs': (context) => LoggingView(),
    //     '/signIn': (context) => AuthView(),
    //   },
    // );
  }
}
