import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/services/global_state_service.dart';
import 'package:mit_dir_utility/views/authentication_view.dart';
import 'package:mit_dir_utility/views/database_view.dart';
import 'package:mit_dir_utility/views/home_view.dart';
import 'package:mit_dir_utility/views/signing_view.dart';
import 'package:mit_dir_utility/views/runtime_logging_view.dart';
// import 'package:flutterapp/views/contact_view.dart';
// import 'package:flutterapp/views/content_view.dart';
import 'package:mit_dir_utility/views/super_view.dart';
// import 'package:flutterapp/modules/markdown_editor_module.dart';
// import 'package:flutterapp/modules/posts_showcase_module.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/views/timetable_view.dart';
import 'package:provider/provider.dart';

class RoutingService {
  int currentRouteIndex = 0;

  ScrollController scrollController = ScrollController();

  ///
  /// How to add a new route:
  /// 1. Add the route path to the routePaths list.
  /// 2. Add the route path to the switch statement in the _getChild method.
  ///

  // List<String> routePaths = [
  //   '/',
  //   '/logs',
  //   '/database',
  //   '/markdowntest',
  //   '/authorization',
  // ];

  // Widget _getChild(String path, BuildContext context) {
  //   switch (path) {
  //     case '/':
  //       const child = HomeView();
  //       // _getSidebarActionsHelper(context, child);
  //       return child;

  //     case '/logs':
  //       const child = RuntimeLoggingView();
  //       // _getSidebarActionsHelper(context, child);
  //       return child;

  //     case '/database':
  //       var child = DatabaseView();
  //       // _getSidebarActionsHelper(context, child);
  //       return child;

  //     case '/markdowntest':
  //       const child = HomeView();
  //       // _getSidebarActionsHelper(context, child);
  //       return child;

  //     case '/authorization':
  //       const child = AuthView();
  //       // _getSidebarActionsHelper(context, child);
  //       return child;

  //     default:
  //       return const Center(
  //           child: Text('ERROR',
  //               style: TextStyle(
  //                 color: Colors.red,
  //               )));
  //   }
  // }

  Map<String, Widget Function(BuildContext)> routeBuilders = {
    '/': (context) {
      var widget = const HomeView();
      if (widget is SidebarActionsInterface) {
        Provider.of<GlobalStateService>(context, listen: false)
            .sidebarActions = widget.sidebarActions;  
      }
      return widget;
    },
    
    '/logs': (context) => const RuntimeLoggingView(),
    '/database': (context) => const DatabaseView(),
    '/timetable': (context) => const TimetableView(),
    '/signing': (context) => const SigningView(),
    '/authorization': (context) => const AuthView(),
  };

  static String titleFormRoutePath(String path) {
    if (path == '/') return 'Home';
    final withoutSlash = path.replaceAll('/', '');
    final firstLetterUpper = withoutSlash[0].toUpperCase();
    final withoutFirstLetter = withoutSlash.substring(1);
    return '$firstLetterUpper$withoutFirstLetter';
  }

  // NOTE: This is form the change notifier sidebar method
  // void _getSidebarActionsHelper(BuildContext context, Widget child) {
  //   var sidebarActionsProvider = child as SidebarActionsInterface;
  //   Provider.of<SidebarActionsNotifier>(context, listen: false)
  //       .setSidebarActions(sidebarActionsProvider.sidebarActions);
  // }

  Widget _transitionBuilder(context, animation, secondaryAnimation, child) {
    final routerState = GoRouterState.of(context);
    // var nextRouteIndex = routePaths.indexOf(routerState.path!);
    var nextRouteIndex = routeBuilders.keys.toList().indexOf(routerState.path!);
    double beginOffsetX = currentRouteIndex < nextRouteIndex ? 1.0 : -1.0;

    currentRouteIndex = nextRouteIndex;

    // TODO: Find a way to scroll back to top when trasitioning.
    // scrollController.animateTo(0,
    //     curve: Curves.bounceInOut, duration: Duration(milliseconds: 100));

    // scrollController.jumpTo(1);

    return SlideTransition(
      position: animation.drive(Tween<Offset>(
        begin: Offset(beginOffsetX, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.bounceInOut))),
      child: child,
    );
  }

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  late final router = GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          var sidebarActions = <Widget>[];
          if (child is SidebarActionsInterface) {
            sidebarActions = ((child as Widget) as SidebarActionsInterface).sidebarActions;
          }
          // print(child.runtimeType);
          return SuperView(
            sidebarActions: sidebarActions,
            child: child,
          );
        },
        // routes: routePaths.asMap()
        routes: routeBuilders.entries
            .map<GoRoute>((entry) => GoRoute(
                // path: routePaths[entry.key],
                path: entry.key,
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                      key: state.pageKey,
                      transitionsBuilder: _transitionBuilder,
                      child: Builder(builder: entry.value));
                  // child: _getChild(entry.value, context));
                }))
            .toList())
  ]);
}
