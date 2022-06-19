// Copyright 2021 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:andrious/src/view.dart';
import 'package:flutter/material.dart';

import 'package:universal_html/html.dart' show window;

/// A delegate that configures a widget, typically a [Navigator]
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with
        //ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AppRoutePath> {
  /// Provide the Map of 'Routes' as well as ADD and Remove routines.
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
    _currentConfiguration = AppRoutePath.home();
    _routes = _mapPages(routes);
  }

  //
  static AppRouterDelegate? _this;

  /// The Map of specified 'routes'
  final Map<String, WidgetBuilder> routes;

  /// Add a listener when the route is called.
  final void Function(VoidCallback listener)? add;

  /// Remove a listener
  final void Function(VoidCallback listener)? remove;
  final GlobalKey<NavigatorState>? _navigatorKey;

  /// Specify the 'home' Page object.
  Page<dynamic>? homePage;

  final List<Page<dynamic>> _pages = [];

  /// The Widget Builder to produce the home screen.
  late WidgetBuilder home;

  /// The current configuration
  static late AppRoutePath _currentConfiguration;

  late Map<String, Page<dynamic>> _routes;

  /// Of course, You're free to override this function if you like
  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// Route assigned by NextRoute() function
  static bool _calledNextRoute = false;

  static bool _backButtonPushed(String path) =>
      !_calledNextRoute && _currentConfiguration.path == path;

  /// Of course, You're free to override this function if you like
  /// This getter will update the current URL path
  @override
  AppRoutePath get currentConfiguration => _currentConfiguration;

  /// Of course, You're free to override this function if you like
  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: [
          homePage ??= _materialPage(context, '/', home),
          // Navigator 2.0 is declarative! Update _pages appropriately.
          if (_pages.isNotEmpty) _pages.last,
        ],
        // Navigator 1.0
        onPopPage: (route, result) {
          //
          final pop = route.didPop(result);

          if (pop) {
            //
            _currentConfiguration = _previousPath();

            // Notify Navigator 2.0
            notifyListeners();
          }
          return pop;
        },
        reportsRouteUpdateToEngine: true,
      );

  /// Of course, You're free to override this function if you like
  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    //
    if (configuration.isHomePage) {
      _currentConfiguration = configuration;
    } else
    // If not a recognized path
    if (!_addPage(configuration.path)) {
      //
      _addUnknown(configuration.path);

      _currentConfiguration = AppRoutePath.unknown(configuration.path);
      // This is a hack! There must be a better way.
    } else if (_backButtonPushed(configuration.path!)) {
      //
      _currentConfiguration = _previousPath();
    } else {
      _currentConfiguration = AppRoutePath.page(configuration.path);
    }
  }

  /// Supply the next route
  static bool nextRoute(String? path) {
    //
    final next = _this!._addPage(path);

    if (next) {
      _calledNextRoute = true;
      _currentConfiguration = AppRoutePath.page(path);
      _this!.notifyListeners();
      _calledNextRoute = false;
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

    final add = pageBuilder != null;

    if (add) {
      // Don't repeatedly add a page. .last will error if empty.
      if (_pages.isEmpty || _pages.last != pageBuilder) {
        _pages.add(pageBuilder);
      }
    }
    return add;
  }

  /// Retreat to the previous path.
  AppRoutePath _previousPath() {
    //
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }

    final path = _pages.isEmpty ? '/' : _pages.last.name;

    return path == '/' ? AppRoutePath.home() : AppRoutePath.page(path);
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
  /// Instantiate only one instance of the Parser.
  factory AppRouteInformationParser() =>
      _this ??= AppRouteInformationParser._();
  AppRouteInformationParser._();
  static AppRouteInformationParser? _this;

  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final path = routeInformation.location;

    //
    if (path == null) {
      return AppRoutePath.home();
    }

    // It's the very same path??
    if (path == AppRouterDelegate._currentConfiguration.path) {
      return AppRouterDelegate._currentConfiguration;
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
    return AppRoutePath.unknown(path);
  }

  /// Restore to the current configuration
  /// It is the responsibility of the delegate to restore its internal
  /// state based on the provided configuration.
  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    //
    if (AppRouterDelegate._currentConfiguration.path != configuration.path) {
      //
      configuration = AppRouterDelegate._currentConfiguration;
    }
    return RouteInformation(location: configuration.path, state: configuration);
  }
}

/// Of course, You're free to override this class if you like
class AppRoutePath {
  /// Identified as the 'home' page.
  AppRoutePath.home()
      : path = '/',
        isUnknown = false,
        isHomePage = true;

  /// Identified as a Page.
  AppRoutePath.page(this.path)
      : isUnknown = false,
        isHomePage = false;

  /// Indentified as an 'unknown' page.
  AppRoutePath.unknown([String? _path])
      : path = _path ?? '/404',
        isUnknown = true,
        isHomePage = false;

//  final AppRouteState? state;
  /// The path
  final String? path;

  /// Indicates if the page is unknown.
  final bool isUnknown;

  /// Indicates if it is a 'home' page.
  final bool isHomePage;

  /// Converts the AppRoutePath object as a Json object.
  Map<String, Object> toJson() => <String, Object>{
        'path': path ?? '',
        'isUnknown': isUnknown,
        'isHomePage': isHomePage,
      };

  /// Returns an AppRoutePath object for a Json object.
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

/// The Route Provider for the App
class AppRouteInformationProvider extends PlatformRouteInformationProvider {
  /// Route Provider for the App is instantiated any number of times.
  AppRouteInformationProvider()
      : super(initialRouteInformation: _initialRouteInformation());

  static RouteInformation _initialRouteInformation() {
    String path = WidgetsBinding.instance.window.defaultRouteName;
    final String url = urlPath();
    if (url.isNotEmpty && url != path) {
      path = url;
    }
    return RouteInformation(location: path);
  }

  /// Returns a empty Map if an error occurs.
  Map<String, String> params() {
    Uri uri;
    Map<String, String> params;
    try {
      uri = Uri.dataFromString(window.location.href);
      params = uri.queryParameters;
    } catch (ex) {
      // Empty if there's a problem
      params = {};
    }
    return params;
  }

  /// Returns the url path if any
  /// Returns an empty string otherwise.
  static String urlPath() {
    String? path;
    try {
      // I get an 'Operand of null-aware' error otherwise. Strange.
      path = window.location.pathname;
    } catch (ex) {
      path = null;
    }
    return path ?? '';
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
