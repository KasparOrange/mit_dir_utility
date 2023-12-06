import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/modules/color_palette_module.dart';
import 'package:mit_dir_utility/modules/profile_module.dart';
import 'package:mit_dir_utility/modules/background_logo_module.dart';
import 'package:mit_dir_utility/services/keyboard_service.dart';
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
    return Consumer<User?>(
      builder: (context, userValue, child) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            leadingWidth:
                1000, // TODO: Make this depend on the size of the buttons. MaterialButton min width 88. Make TextButtonStyle so.
            leading: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // children: routingService.routePaths.map((e) {
                children: [
                  ...RoutingService.routeBuilders.keys.map((e) {
                    Color? color;
                    double? elevation;
                    Widget? child;
                    EdgeInsets? padding;
                    if (userValue == null && e != '/') {
                      return const SizedBox(width: 0);
                    }
                    if (e == GoRouter.of(context).location) {
                      color = Colors.amber;
                      elevation = 0;
                    }
                    if (e == '/') {
                      child = Image.asset(
                        'assets/images/logo_brown.png',
                        color: Colors.black,
                      );
                      padding = const EdgeInsets.only(left: 10, right: 10);
                    } else {
                      child = Text(RoutingService.titleFormRoutePath(e));
                    }
                    return TextButton(
                      onPressed: () => context.go(e),
                      style: TextButton.styleFrom(
                        backgroundColor: color,
                        elevation: elevation,
                        padding: padding,
                      ),

                      child: child,
                    );
                  }).toList(),
                ]),
            actions: const [
              Tooltip(message: 'SHIFT + J = Left\nSHIFT + K = Right', child: Icon(Icons.keyboard)),
              SizedBox(width: 30),
              ProfileModule(),
            ],
          ),
          body: Builder(builder: (context) {
            return KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => KeyboardService.keyHandler(
                event: event,
                context: context,
              ),
              child: Row(children: [
                Consumer<SidebarState>(
                  builder: (context, value, child) {
                    return value.widgets.isEmpty ? const SizedBox(width: 0) : const SidebarModule();
                  },
                ),
                Expanded(
                  child: Stack(children: [
                    const BackgroundLogoModule(),
                    Column(children: [
                      const SizedBox(height: 5),
                      Expanded(
                        child: Builder(builder: (context) {
                          return widget.child;
                        }),
                      ),
                    ],
                    ),
                  ]),
                ),
              ]),
            );
          })),
    );
  }
}
