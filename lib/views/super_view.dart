import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/background_logo_module.dart';
import 'package:mit_dir_utility/modules/impressum_module.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/global_state_service.dart';
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
  SuperView({super.key, required this.child, required this.sidebarActions});

  final Widget child;
  final List<Widget> sidebarActions;

  @override
  State<SuperView> createState() => _SuperViewState();
}

class _SuperViewState extends State<SuperView> {
  var currentTitle = 'Home';
  void setCurrentTitel(title) {
    setState(() => currentTitle = title);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final routingService = Provider.of<RoutingService>(context);
    final keyboardService = Provider.of<KeyboardService>(context);
    // final sidebarActions = context.watch<SidebarActionsNotifier>().sidebarActions;
    // final themeService = Provider.of<ThemeService>(context);
    // final databaseService = Provider.of<DatabaseService>(context);
    // keyboardservice.injectContext(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leadingWidth:
              500, // TODO: Make this depend on the size of the buttons. MaterialButton min width 88. Make TextButtonStyle so.
          leading: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // children: routingService.routePaths.map((e) {
              children: routingService.routeBuilders.keys.map((e) {
                Color? color;
                Widget? child;
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
                  return FutureBuilder<UserModel>(
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
            ElevatedButton(
                onPressed: () {
                  AuthenticationService.signOut();
                },
                child: Text('Sign out'))
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
        drawer: Container(
          color: Colors.amber,
          width: 300,
        ),
        endDrawer: const Placeholder(),
        body: Builder(builder: (context) {
          // var sidebarActions = widget.sidebarActions;

          return KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => keyboardService.keyHandler(
              event: event, context: context,
              // themeService: themeService
            ),
            child: Row(children: [
              if (Provider.of<GlobalStateService>(context).sidebarActions != [])
                ...Provider.of<GlobalStateService>(context).sidebarActions,
              Expanded(
                child: Stack(children: [
                  const BackgroundLogoModule(),
                  Builder(builder: (context) {
                    // if (widget.child is SidebarActionsInterface) {
                    //   print('It is a SidebarActionsInterface');
                    //   sidebarActions = (widget.child as SidebarActionsInterface).sidebarActions;
                    //   Provider.of<GlobalStateService>(context, listen: false).sidebarActions =
                    //       sidebarActions;
                    // }
                    return widget.child;
                  }),
                ]),
              ),
            ]),
          );
        }));
  }
}
