import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/modules/appbar_user_area_module.dart';
import 'package:mit_dir_utility/modules/background_logo_module.dart';
import 'package:mit_dir_utility/services/keyboard_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/routing_service.dart';
import 'package:mit_dir_utility/modules/sidebar_module.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/states/sidebar_state.dart';
import 'package:provider/provider.dart';

class SuperView extends StatefulWidget {
  const SuperView({super.key, required this.child, required this.sidebarActions});

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

    return Consumer<User?>(
      builder: (context, userValue, child) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            leadingWidth:
                500, // TODO: Make this depend on the size of the buttons. MaterialButton min width 88. Make TextButtonStyle so.
            leading: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // children: routingService.routePaths.map((e) {
                children: RoutingService.routeBuilders.keys.map((e) {
                  Color? color;
                  Widget? child;
                  if (userValue == null && e != '/') {
                    return const SizedBox(width: 0);
                  }
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
                  }
                  return MaterialButton(
                    onPressed: () => context.go(e),
                    color: color,
                    child: child,
                  );
                }).toList()),
            actions: const [
              Tooltip(message: 'SHIFT + J = Left\nSHIFT + K = Right', child: Icon(Icons.keyboard)),
              SizedBox(width: 30),
              AppbarUserAreaModule(),
            ],
          ),
          body: Builder(builder: (context) {
            log('SuperView first builder triggers', onlyDebug: true);
            final sidebarWidgets = Provider.of<SidebarState>(context, listen: false).widgets;
            return KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => keyboardService.keyHandler(
                event: event,
                context: context,
              ),
              child: Row(children: [
                Consumer<SidebarState>(
                  builder: (context, value, child) {
                    if (value.widgets.isEmpty) {
                      return const SizedBox(width: 0);
                    } else {
                      return const SidebarModule();
                    }
                  },
                ),
                // if (sidebarWidgets.isNotEmpty)
                //     Builder(builder: (context) {
                //       log('SuperView second builder triggers');
                //       return const SidebarModule();
                //     }),
                Expanded(
                  child: Stack(children: [
                    const BackgroundLogoModule(),
                    Builder(builder: (context) {
                      return widget.child;
                    }),
                  ]),
                ),
              ]),
            );
          })),
    );
  }
}
