import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/keyboard_service.dart';
// import 'package:mit_dir_utility/services/database_service.dart';
// import 'package:mit_dir_utility/services/keyboard_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
// import 'package:mit_dir_utility/services/theme_service.dart';
// import 'package:mit_dir_utility/trash/app_bar_user_area.dart';
// import 'package:mit_dir_utility/views/content_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';

class SuperView extends StatefulWidget {
  const SuperView({super.key, required this.child});

  final Widget child;

  @override
  State<SuperView> createState() => _SuperViewState();
}

class _SuperViewState extends State<SuperView> {
  var currentTitle = 'Home';
  void setCurrentTitel(title) {
    setState(() => currentTitle = title);
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);
    final routingService = Provider.of<RoutingService>(context);
    final keyboardService = Provider.of<KeyboardService>(context);
    // final themeService = Provider.of<ThemeService>(context);
    // final databaseService = Provider.of<DatabaseService>(context);
    // keyboardservice.injectContext(context);
    return KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => keyboardService.keyHandler(
              event: event, context: context,
              // themeService: themeService
            ),
        child: Scaffold(
          appBar: AppBar(
            // title: Text(
            //   'MitDir',
            //   style: TextStyle(
            //       fontSize: 50,
            //       fontWeight: FontWeight.bold,
            //       color: Theme.of(context).colorScheme.secondary),
            //   textAlign: TextAlign.center,
            // ),
            centerTitle: true,
            leadingWidth:
                500, // TODO: Make this depend on the size of the buttons. MaterialButton min width 88. Make TextButtonStyle so.
            leading: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: routingService.routePaths.map((e) {
                  Color? color;
                  Widget child;
                  if (e == GoRouter.of(context).location) {
                    color = Colors.amber;
                  }
                  if (e == '/') {
                    child = Image.asset(
                      'assets/images/logo_brown.png',
                      color: Colors.black,
                    );
                  } else {
                    child = Text(RoutingService.titleFormRoutePath(e));
                    // child = Text('RoutePlaceholder');
                  }
                  return MaterialButton(
                    onPressed: () => context.go(e),
                    color: color,
                    child: child,
                  );
                }).toList()),
            actions: [
              // MaterialButton(
              //   onPressed: databaseService.test,
              //   child: const Text('TEST'),
              // ),
              const Tooltip(
                  message: 'SHIFT + J = Left\nSHIFT + K = Right', child: Icon(Icons.keyboard)),

              Consumer<User?>(
                builder: (BuildContext context, value, Widget? child) {
                  if (value == null) {
                    return Text('No user signed in');
                  } else {
                    return FutureBuilder(
                        future: DatabaseService.readPersonInFBFireStore(uid: value.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final person = snapshot.data!;
                            return Text('${person.firstName} ${person.lastName} is logged in!');
                          } else {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              
                              print(snapshot.stackTrace);

                              Provider.of<RuntimeLoggingService>(context)
                                  .appendLog(snapshot.error.toString());
                            }
                            return Placeholder();
                          }
                        });

                    // return Text('The user: ${(value as UserModel).}');
                  }
                },
              ),
              ElevatedButton(onPressed: () {
                AuthenticationService.signOut();
              }, child: Text('Sign out'))
              // child: Text('No user signed in'))
              // MaterialButton(
              //   onPressed: () {
              //     // themeService.toggleThemeMode();
              //     // log(themeService.themeMode);
              //   },
              //   child: Text('DarkModePlaceholder')
              //   // child: themeService.themeMode == ThemeMode.light
              //   //     ? const Icon(Icons.dark_mode)
              //   //     : const Icon(Icons.light_mode_sharp),
              // ),
              // const AppBarUserArea()
            ],
          ),
          body: Stack(children: [
            Container(
              height: 1000,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/logo_brown.png'),
                      opacity: 0.2,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.topCenter),
                  gradient: LinearGradient(
                      colors: [Theme.of(context).colorScheme.primary, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  backgroundBlendMode: BlendMode.darken),
            ),
            ListView(
                controller: routingService.scrollController,
                addSemanticIndexes: true,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                children: [
                  Container(
                    height: 500,
                    child: widget.child,
                    // NOTE: Comes from: file:///C:/SELF/Code/flutter/flutterapp/lib/services/route_service.dart
                  ),
                  Container(
                    color: Colors.amber,
                    height: 200,
                  ),
                ]),
          ]),
        ));
  }
}
