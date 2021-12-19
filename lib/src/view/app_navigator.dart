// Copyright 2021 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:andrious/src/view.dart';
import 'package:flutter/material.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  factory AppRouterDelegate({
    required Map<String, WidgetBuilder> routes,
    void Function(VoidCallback listener)? add,
    void Function(VoidCallback listener)? remove,
  }) =>
      _this ??= AppRouterDelegate._(
        routes: routes,
        add: add,
        remove: remove,
      );

  AppRouterDelegate._({
    required this.routes,
    this.add,
    this.remove,
  }) : _navigatorKey = GlobalKey<NavigatorState>() {
    _routes = _mapPages(routes);
  }
  //
  static AppRouterDelegate? _this;

  final Map<String, WidgetBuilder> routes;
  final void Function(VoidCallback listener)? add;
  final void Function(VoidCallback listener)? remove;
  final GlobalKey<NavigatorState>? _navigatorKey;

  Page<dynamic>? homePage;
  final List<Page<dynamic>> _pages = [];

  late WidgetBuilder home;
  late Map<String, Page<dynamic>> _routes;

  /// Of course, You're free to override this function if you like
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// Of course, You're free to override this function if you like
  /// This getter will update the current URL path
  @override
  AppRoutePath get currentConfiguration {
    AppRoutePath route;
    final path = _pages.isEmpty ? '/' : _pages.last.name;

    if (_foundRoute(path)) {
      route = path == '/' ? AppRoutePath.home() : AppRoutePath.page(path);
    } else {
      route = AppRoutePath.unknown();
    }
    return route;
  }

  /// Of course, You're free to override this function if you like
  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey, // UniqueKey(),
        pages: [
          homePage ??= _materialPage(context, '/', home),
          if (_pages.isNotEmpty) _pages.last,
        ],
        onPopPage: (route, result) {
          //
          final pop = route.didPop(result);

          if (pop) {
            //
            if (_pages.isNotEmpty) {
              _pages.removeLast();
            }

            notifyListeners();
          }
          return pop;
        },
      );

  /// Of course, You're free to override this function if you like
  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    //
    if (configuration.isWebPage) {
      // If not a recognized path
      if (!_addPage(configuration.path)) {
        _addUnknown(configuration.path);
      }
    } else if (!configuration.isHomePage) {
      _addPage('/404');
    }
  }

  /// Supply the next route
  static bool nextRoute(String? path) {
    //
    bool next;

    next = _this!._addPage(path);

    if (next) {
      _this!.notifyListeners();
    }
    return next;
  }

  /// Add the next page route
  bool _addPage(String? path) {
    //
    if (path == null) {
      return false;
    }

    path = path.trim();

    if (path.isEmpty) {
      return false;
    }

    // The 'root' should always be found.
    if (path == '/') {
      return true;
    }

    final pageBuilder = _this!._routes[path];

    bool add = pageBuilder != null;

    // Don't repeatedly add a page.
    if (add) {
      add = _pages.isEmpty || _pages.last != pageBuilder;
    }

    if (add) {
      _pages.add(pageBuilder!);
    }
    return add;
  }

  /// Find the specified path in the 'routes' map.
  bool _foundRoute(String? path) {
    //
    if (path == null) {
      return false;
    }

    path = path.trim();

    if (path.isEmpty) {
      return false;
    }

    // The 'root' should always be found.
    if (path == '/') {
      return true;
    }

    return _this!._routes[path] != null;
  }

  /// Explicitly add a route.
  bool _addRoute(String? path, WidgetBuilder? builder) {
    //
    if (path == null || builder == null) {
      return false;
    }

    path = path.trim();

    if (path.isEmpty) {
      return false;
    }

    // The 'root' should always be found.
    if (path == '/') {
      return true;
    }

    final newPage = _webPage(path, builder);

    // Test if already added.
    final page = _routes[path];

    // Add if not there or an old route.
    if (page == null || page != newPage) {
      _routes[path] = newPage;
    }

    return _routes[path] != null;
  }

  /// Compose the webpages for this app.
  Map<String, Page<dynamic>> _mapPages(Map<String, WidgetBuilder> routes) {
    //
    const root = '/';

    // Ensure there is a 'home' page.
    if (routes.containsKey(root)) {
      home = routes.remove(root)!;
    } else {
      home = routes.remove(routes.entries.first.key)!;
    }

    const notFound = '/404';

    // Ensure there's an '404' entry
    if (!routes.containsKey(notFound)) {
      if (routes.containsKey('404')) {
        routes[notFound] = routes.remove('404')!;
      } else {
        routes[notFound] = (_) => _UnknownScreen();
      }
    }

    // Create a new map for the 'web pages'
    final Map<String, Page<dynamic>> pages = {};

    routes.forEach((path, builder) {
      pages[path] = _webPage(
        path,
        builder,
      );
    });

    return pages;
  }

  /// Include an 'unknown' path to the pages as a 404 screen.
  bool _addUnknown(String? path) {
    bool add = _addRoute(path, (_) => _UnknownScreen());
    if (add) {
      add = _addPage(path);
    }
    return add;
  }
}

/// Parser inspired by https://github.com/acoutts/flutter_nav_2.0_mobx/blob/master/lib/main.dart
/// Converts a route into the user class type, <T>
/// Using typed information instead of string allows for greater flexibility
class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  //
  factory AppRouteInformationParser() =>
      _this ??= AppRouteInformationParser._();
  AppRouteInformationParser._();
  static AppRouteInformationParser? _this;

  @override
  Future<AppRoutePath> parseRouteInformation(
          RouteInformation routeInformation) async =>
      _parseRoutePath(routeInformation.location);

  /// Restore to the current configuration
  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) =>
      RouteInformation(location: configuration.path, state: configuration);
}

/// Return the appropriate AppRoutePath object with it's specific URL
AppRoutePath _parseRoutePath(String? path) {
  //
  if (path == null) {
    return AppRoutePath.home();
  }

  final uri = Uri.parse(path);

  if (uri.pathSegments.isEmpty) {
    return AppRoutePath.home();
  }

  // Handle '/book/:id'
  if (uri.pathSegments.length == 2) {
    //
    // if (!uri.pathSegments[0].startsWith('/')) {
    //   return AppRoutePath.unknown();
    // }

    var remaining = uri.pathSegments[1];

    if (remaining.isEmpty) {
      return AppRoutePath.unknown();
    }

    if (!remaining.startsWith('/')) {
      remaining = '/$remaining';
    }

    return AppRoutePath.page(remaining);
  } else if (uri.pathSegments.length == 1) {
    //
    return AppRoutePath.page(uri.path);
  }
  // Handle unknown routes
  return AppRoutePath.unknown();
}

/// Of course, You're free to override this class if you like
class AppRoutePath {
  //
  AppRoutePath.home()
      : path = '/',
        isUnknown = false,
        isHomePage = true,
        isWebPage = false;

  AppRoutePath.page(this.path)
      : isUnknown = false,
        isHomePage = false,
        isWebPage = true;

  AppRoutePath.unknown()
      : path = '/404',
        isUnknown = true,
        isHomePage = false,
        isWebPage = false;

//  final AppRouteState? state;
  final String? path;
  final bool isUnknown;
  final bool isHomePage;
  final bool isWebPage;

  Map<String, Object> toJson() => <String, Object>{
        'path': path ?? '',
        'isUnknown': isUnknown,
        'isHomePage': isHomePage,
        'isWebPage': isWebPage
      };

  AppRoutePath fromJson(Map<String, dynamic> json) {
    AppRoutePath route;

    String? path;
    final dynamic value = json['path'];

    if (value is String) {
      path = value;
    } else {
      path = '';
    }

    if (path.trim().isEmpty) {
      path = '/404';
    }

    switch (path) {
      case '/':
        route = AppRoutePath.home();
        break;
      case '/404':
        route = AppRoutePath.unknown();
        break;
      default:
        route = AppRoutePath.page(path);
    }
    return route;
  }
}

/// Returns a Page object.
Page<dynamic> _webPage(
  String path,
  WidgetBuilder builder, {
  LocalKey? key,
  String? name,
  Object? arguments,
  String? restorationId,
}) =>
    _WebPage(
      key: key ?? ValueKey(path),
      name: name ?? path,
      arguments: arguments,
      restorationId: restorationId,
      builder: builder,
    );

/// Returns a MaterialPage object.
MaterialPage<dynamic> _materialPage(
  BuildContext context,
  String path,
  WidgetBuilder builder, {
  bool? maintainState,
  bool? fullscreenDialog,
  LocalKey? key,
  String? name,
  Object? arguments,
  String? restorationId,
}) {
  Widget? widget;

  try {
    widget = builder(context);
  } catch (ex) {
    // Those in error are not included!
    widget = null;
    assert(widget != null, '$builder generated an error!');
  }

  return MaterialPage<void>(
    maintainState: maintainState ?? true,
    fullscreenDialog: fullscreenDialog ?? true,
    key: key ?? ValueKey('$path/${widget.toString()}'),
    name: name ?? path,
    arguments: arguments,
    restorationId: restorationId,
    child: widget ?? Container(),
  );
}

class _WebPage extends Page<void> {
  const _WebPage({
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
    this.builder,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );
  final WidgetBuilder? builder;

  @override
  Route<void> createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: builder ?? (BuildContext context) => const SizedBox(),
      );
}

class _UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('''
          404 Webpage not found

The site configured at this address does not contain the requested webpage.

If this is your site, make sure that the filename case matches the URL.
For root URLs (like http://example.com/) you must provide an index.html file.
          '''),
        ),
      );
}
