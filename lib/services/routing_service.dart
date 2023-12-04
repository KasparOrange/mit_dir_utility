import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/services/global_state_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/states/sidebar_state.dart';
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

  Map<String, Widget Function(BuildContext)> routeBuilders = {
    '/': (context) {
      const widget = HomeView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
    '/logs': (context) {
      const widget = RuntimeLoggingView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
    '/database': (context) {
      const widget = DatabaseView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
    '/timetable': (context) {
      const widget = TimetableView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
    '/signing': (context) {
      const widget = SigningView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
    '/authorization': (context) {
      const widget = AuthView();

      assert(widget is SidebarInterface);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SidebarState>(context, listen: false).widgets = widget.sidebarWidgets;
        log('EXTERN Setting sidebar widgets to: ${widget.sidebarWidgets}');
      });

      return widget;
    },
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

  // NOTE: Old transition builder
  // Widget _transitionBuilder(context, animation, secondaryAnimation, child) {
  //   final routerState = GoRouterState.of(context);
  //   // var nextRouteIndex = routePaths.indexOf(routerState.path!);
  //   var nextRouteIndex = routeBuilders.keys.toList().indexOf(routerState.path!);
  //   double beginOffsetX = currentRouteIndex < nextRouteIndex ? 1.0 : -1.0;

  //   currentRouteIndex = nextRouteIndex;

  //   // TODO: Find a way to scroll back to top when trasitioning.
  //   // scrollController.animateTo(0,
  //   //     curve: Curves.bounceInOut, duration: Duration(milliseconds: 100));

  //   // scrollController.jumpTo(1);

  //   return SlideTransition(
  //     position: animation.drive(Tween<Offset>(
  //       begin: Offset(beginOffsetX, 0),
  //       end: Offset.zero,
  //     ).chain(CurveTween(curve: Curves.bounceInOut))),
  //     child: child,
  //   );
  // }

  // NOTE: New transition builder
  Widget _transitionBuilder(context, animation, secondaryAnimation, child) {
    // Determine the direction of the transition
    final routerState = GoRouterState.of(context);
    var nextRouteIndex = routeBuilders.keys.toList().indexOf(routerState.path!);
    double beginOffsetX = currentRouteIndex < nextRouteIndex ? 1.0 : -1.0;
    currentRouteIndex = nextRouteIndex;

    // Slide-in transition for the incoming page
    var slideInTransition = SlideTransition(
      position: animation.drive(Tween<Offset>(
        begin: Offset(beginOffsetX, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut))),
      child: child,
    );

    // Slide-out transition for the outgoing page
    var slideOutTransition = _previousPage != null
        ? SlideTransition(
            position: secondaryAnimation.drive(Tween<Offset>(
              begin: Offset.zero,
              end: Offset(-beginOffsetX, 0),
            ).chain(CurveTween(curve: Curves.easeInOut))),
            child: _previousPage!,
          )
        : const SizedBox.shrink(); // Fallback to an empty widget if no previous page

    return Stack(
      children: [
        slideOutTransition, // This will be the previous page
        slideInTransition, // This will be the new page
      ],
    );
  }

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  Widget? _previousPage;

  late final CustomRouteObserver _routeObserver = CustomRouteObserver(this);

  void _updatePreviousPage(BuildContext context, String currentPath) {
    _previousPage = routeBuilders[currentPath]?.call(context);
  }

  void _updatePreviousPageOnPush(String? previousRouteName) {
    if (previousRouteName != null) {
      print(previousRouteName);
      _previousPage = routeBuilders[previousRouteName]?.call(_rootNavigatorKey.currentContext!);
    }
  }

  late final router = GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          var sidebarActions = <Widget>[];
          // if (child is SidebarInterface) {
          //   sidebarActions = (child as SidebarInterface).sidebarWidgets;
          // }

          log('Building ShellRoute');

          // log(child.runtimeType);
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

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  CustomRouteObserver(this._routingService);

  final RoutingService _routingService;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute) {
      // Update the previous page when a new route is pushed
      _routingService._updatePreviousPageOnPush(previousRoute.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      // Handle pop event if necessary
    }
  }
}
