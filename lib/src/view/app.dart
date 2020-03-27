///
/// Copyright (C) 2018 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  24 Dec 2018
///

import 'dart:io' show Platform;

import 'dart:async' show Future, StreamSubscription;

import 'package:flutter/foundation.dart'
    show Key, kIsWeb, mustCallSuper, protected;

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:package_info/package_info.dart' show PackageInfo;

import 'package:flutter/widgets.dart';

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;

import 'package:mvc_application/src/controller/app.dart'
    show AppController, ErrorHandler;

import 'package:mvc_application/mvc.dart' show AppError;

import 'package:mvc_application/app.dart' show AppMVC;

import 'package:mvc_application/controller.dart'
    show AlarmManager, ControllerMVC;

import 'package:mvc_application/view.dart' show AppMenu, SetState;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_application/controller.dart' show Assets;

import 'package:mvc_application/model.dart' show Files;

import 'package:mvc_application/model.dart' show InstallFile;

import 'package:prefs/prefs.dart' show Prefs;

/// Highlights UI while debugging.
import 'package:flutter/rendering.dart' as debugPaint;

/// Error Screen Builder if an error occurs.
typedef ErrorWidgetBuilder = Widget Function(
    FlutterErrorDetails flutterErrorDetails);

abstract class App extends AppMVC {
  // You must supply a 'View.'
  App({ControllerMVC con, Key key, this.loadingScreen})
      : super(con: con, key: key);

  @protected
  AppView createView();

  // Not a good idea I don't think, Greg. gp
//  static AppView get appView => _vw;
  static AppView _vw;

  static AsyncSnapshot get snapshot => _snapshot;
  static AsyncSnapshot _snapshot;

  final Widget loadingScreen;
  static bool hotLoad = false;

  /// More efficient widget tree rebuilds
  static final materialKey = GlobalKey();

  @override
  void initApp() {
    super.initApp();
    AlarmManager.init();
    _vw = createView();
    _vw?.con?.initApp();
  }

  @override
  Widget build(BuildContext context) {
    Assets.init(context);
    _context = context;
    return FutureBuilder<bool>(
      future: init(),
      initialData: false,
      builder: (_, snapshot) => _App.show(snapshot, loadingScreen),
    );
  }

  @override
  Future<bool> init() async {
    if (hotLoad) {
      _vw = createView();
      _vw?.con?.initApp();
    } else {
      await _initInternal();
      if (!kIsWeb) _packageInfo = await PackageInfo.fromPlatform();
    }
    _isInit = await super.init();
    if (_isInit) _isInit = await _vw.init();
    return _isInit;
  }

  @mustCallSuper
  void dispose() {
    _context = null;
    _scaffold = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    super.dispose();
  }

  /// Determine if the App initialized successfully.
  static bool get isInit => _isInit;
  static bool _isInit = false;

  // Use Material UI when explicitly specified or even when running in iOS
  static bool get useMaterial =>
      _vw._useMaterial ||
      (Platform.isAndroid && !_vw.switchUI) ||
      (Platform.isIOS && _vw.switchUI);

  // Use Cupertino UI when explicitly specified or even when running in Android
  static bool get useCupertino =>
      _vw._useCupertino ||
      (Platform.isIOS && !_vw.switchUI) ||
      (Platform.isAndroid && _vw.switchUI);

  static GlobalKey<NavigatorState> get navigatorKey => _vw.navigatorKey;
  static set navigatorKey(GlobalKey<NavigatorState> v) {
    if (v != null) _vw.navigatorKey = v;
  }

  static Map<String, WidgetBuilder> get routes => _vw.routes;
  static set routes(Map<String, WidgetBuilder> v) {
    if (v != null) _vw.routes = v;
  }

  static String get initialRoute => _vw.initialRoute;
  static set initialRoute(String v) {
    if (v != null) _vw.initialRoute = v;
  }

  static RouteFactory get onGenerateRoute => _vw.onGenerateRoute;
  static set onGenerateRoute(RouteFactory v) {
    if (v != null) _vw.onGenerateRoute = v;
  }

  static RouteFactory get onUnknownRoute => _vw.onUnknownRoute;
  static set onUnknownRoute(RouteFactory v) {
    if (v != null) _vw.onUnknownRoute = v;
  }

  static List<NavigatorObserver> get navigatorObservers =>
      _vw.navigatorObservers;
  static set navigatorObservers(List<NavigatorObserver> v) {
    if (v != null) _vw.navigatorObservers = v;
  }

  static TransitionBuilder get builder => _vw.builder;
  static set builder(TransitionBuilder v) {
    if (v != null) _vw.builder = v;
  }

  static String get title => _vw.title;
  static set title(String v) {
    if (v != null) _vw.title = v;
  }

  static GenerateAppTitle get onGenerateTitle => _vw.onGenerateTitle;
  static set onGenerateTitle(GenerateAppTitle v) {
    if (v != null) _vw.onGenerateTitle = v;
  }

  // Allow it to be assigned null.
  static ThemeData theme;
  static CupertinoThemeData iOSTheme;

  static Color get color => _vw.color;
  static set color(Color v) {
    if (v != null) _vw.color = v;
  }

  static Locale get locale => _vw.locale;
  static set locale(Locale v) {
    if (v != null) _vw.locale = v;
  }

  static Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _vw.localizationsDelegates;
  static set localizationsDelegates(
      Iterable<LocalizationsDelegate<dynamic>> v) {
    if (v != null) _vw.localizationsDelegates = v;
  }

  static LocaleResolutionCallback get localeResolutionCallback =>
      _vw.localeResolutionCallback;
  static set localeResolutionCallback(LocaleResolutionCallback v) {
    if (v != null) _vw.localeResolutionCallback = v;
  }

  static Iterable<Locale> get supportedLocales => _vw.supportedLocales;
  static set supportedLocales(Iterable<Locale> v) {
    if (v != null) _vw.supportedLocales = v;
  }

  static bool get debugShowMaterialGrid => _vw.debugShowMaterialGrid;
  static set debugShowMaterialGrid(bool v) {
    if (v != null) _vw.debugShowMaterialGrid = v;
  }

  static bool get showPerformanceOverlay => _vw.showPerformanceOverlay;
  static set showPerformanceOverlay(bool v) {
    if (v != null) _vw.showPerformanceOverlay = v;
  }

  static bool get checkerboardRasterCacheImages =>
      _vw.checkerboardRasterCacheImages;
  static set checkerboardRasterCacheImages(bool v) {
    if (v != null) _vw.checkerboardRasterCacheImages = v;
  }

  static bool get checkerboardOffscreenLayers =>
      _vw.checkerboardOffscreenLayers;
  static set checkerboardOffscreenLayers(bool v) {
    if (v != null) _vw.checkerboardOffscreenLayers = v;
  }

  static bool get showSemanticsDebugger => _vw.showSemanticsDebugger;
  static set showSemanticsDebugger(bool v) {
    if (v != null) _vw.showSemanticsDebugger = v;
  }

  static bool get debugShowCheckedModeBanner => _vw.debugShowCheckedModeBanner;
  static set debugShowCheckedModeBanner(bool v) {
    if (v != null) _vw.debugShowCheckedModeBanner = v;
  }

  static bool get debugPaintSizeEnabled => _vw.debugPaintSizeEnabled;
  static set debugPaintSizeEnabled(bool v) {
    if (v != null) _vw.debugPaintSizeEnabled = v;
  }

  static bool get debugPaintBaselinesEnabled => _vw.debugPaintBaselinesEnabled;
  static set debugPaintBaselinesEnabled(bool v) {
    if (v != null) _vw.debugPaintBaselinesEnabled = v;
  }

  static bool get debugPaintPointersEnabled => _vw.debugPaintPointersEnabled;
  static set debugPaintPointersEnabled(bool v) {
    if (v != null) _vw.debugPaintPointersEnabled = v;
  }

  static bool get debugPaintLayerBordersEnabled =>
      _vw.debugPaintLayerBordersEnabled;
  static set debugPaintLayerBordersEnabled(bool v) {
    if (v != null) _vw.debugPaintLayerBordersEnabled = v;
  }

  static bool get debugRepaintRainbowEnabled => _vw.debugRepaintRainbowEnabled;
  static set debugRepaintRainbowEnabled(bool v) {
    if (v != null) _vw.debugRepaintRainbowEnabled = v;
  }

  static BuildContext get context => _context;
  static BuildContext _context;

  static ScaffoldState _scaffold;

  // Application information
  static PackageInfo _packageInfo;

  static String get appName => _packageInfo?.appName;

  static String get packageName => _packageInfo?.packageName;

  static String get version => _packageInfo?.version;

  static String get buildNumber => _packageInfo?.buildNumber;

  /// Determines if running in an IDE or in production.
  static bool get inDebugger => AppMVC.inDebugger;

  /// Refresh the root State object, AppView.
  static void refresh() => _vw.refresh();

  /// Catch and explicitly handle the error.
  static void catchError(Exception ex) => _vw.catchError(ex);

  static ScaffoldState get scaffold => App._getScaffold();

  static ScaffoldState _getScaffold() {
    if (_scaffold == null) _scaffold = Scaffold.of(_context, nullOk: true);
    return _scaffold;
  }

  static ColorSwatch get colorTheme => AppMenu.colorTheme;

  static getThemeData() async {
    String theme = await Prefs.getStringF('theme');
    ThemeData themeData;
    switch (theme) {
      case 'light':
        themeData = ThemeData.light();
        break;
      case 'dark':
        themeData = ThemeData.dark();
        break;
      default:
        themeData = ThemeData.fallback();
    }
    return themeData;
  }

  static setThemeData(String theme) {
    switch (theme) {
      case 'light':
        break;
      case 'dark':
        break;
      default:
        theme = 'fallback';
    }
    Prefs.setString('theme', theme);
  }

  static final Connectivity _connectivity = Connectivity();

  static StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static get filesDir => _path;
  static String _path;

  static String get connectivity => _connectivityStatus;
  static String _connectivityStatus;

  static bool get isOnline => _connectivityStatus != 'none';

  static Set<ConnectivityListener> _listeners = new Set();

  static addConnectivityListener(ConnectivityListener listener) =>
      _listeners.add(listener);

  static removeConnectivityListener(ConnectivityListener listener) =>
      _listeners.remove(listener);

  static clearConnectivityListener() => _listeners.clear();

  static Future<String> getInstallNum() => InstallFile.id();

  static String get installNum => _installNum;
  static String _installNum;

  // Internal Initialization routines.
  static Future<void> _initInternal() async {
    // Determine the theme.
    theme ??= _vw?.theme;
    theme ??= await App.getThemeData();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _listeners.forEach((listener) {
        listener.onConnectivityChanged(result);
      });
    });

    _initConnectivity().then((status) {
      _connectivityStatus = status;
    }).catchError((e) {
      _connectivityStatus = 'none';
    });

    // If running on the web the rest of the code in incompatible.
    if (kIsWeb) return;

    // Get the installation number
    _installNum = await InstallFile.id();

    // Determine the location to the files directory.
    _path = await Files.localPath;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
//TODO   FireBase.didChangeAppLifecycleState(state);
  }

  static Future<String> _initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } catch (ex) {
      connectionStatus = 'Failed to get connectivity.';
    }
    return connectionStatus;
  }
}

class _App {
  static Widget home;

  static Widget show(AsyncSnapshot snapshot, Widget loading) {
    if (snapshot.hasError) {
      App._vw.home = AppError(snapshot.error).home;
      return _AppWidget();
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData &&
        snapshot.data) {
      if (home != null) {
        App._vw.home = home;
      }
      return _AppWidget();
    } else {
      return MaterialApp(
          color: Colors.white,
          home: Container(child: Center(child: CircularProgressIndicator())));
    }
  }
}

class _AppWidget extends StatefulWidget {
  _AppWidget({Key key}) : super(key: key);
  State createState() => App._vw;
}

class AppView extends AppViewState<_AppWidget> {
  AppView({
    this.key,
    this.home,
    AppController con,
    List<ControllerMVC> controllers,
    GlobalKey<NavigatorState> navigatorKey,
    Map<String, WidgetBuilder> routes,
    String initialRoute,
    RouteFactory onGenerateRoute,
    RouteFactory onUnknownRoute,
    List<NavigatorObserver> navigatorObservers,
    TransitionBuilder builder,
    String title,
    GenerateAppTitle onGenerateTitle,
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode,
    Color color,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales,
    this.useMaterial = false,
    this.useCupertino = false,
    this.switchUI = false,
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
    bool debugShowWidgetInspector = false,
    bool debugPaintSizeEnabled = false,
    bool debugPaintBaselinesEnabled = false,
    bool debugPaintPointersEnabled = false,
    bool debugPaintLayerBordersEnabled = false,
    bool debugRepaintRainbowEnabled = false,
    ErrorWidgetBuilder errorScreen,
  }) : super(
          con: con ?? AppController(),
          controllers: controllers,
          navigatorKey: navigatorKey,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: navigatorObservers,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          color: color ?? Colors.white,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowWidgetInspector: debugShowWidgetInspector,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          debugPaintSizeEnabled: debugPaintSizeEnabled,
          debugPaintBaselinesEnabled: debugPaintBaselinesEnabled,
          debugPaintPointersEnabled: debugPaintPointersEnabled,
          debugPaintLayerBordersEnabled: debugPaintLayerBordersEnabled,
          debugRepaintRainbowEnabled: debugRepaintRainbowEnabled,
          errorScreen: errorScreen,
        ) {
    // if both useMaterial & useCupertino are set then rely on the Platform.
    _useMaterial =
        useMaterial && (!useCupertino || Platform.isAndroid || kIsWeb);
    _useCupertino = useCupertino && (!_useMaterial || Platform.isIOS);
  }
  final Key key;
  Widget home;
  // Explicitly use the Material theme
  bool useMaterial;
  bool _useMaterial;
  // Explicitly use the Cupertino theme
  bool useCupertino;
  bool _useCupertino;
  // Use Cupertino UI in Android and vice versa.
  final bool switchUI;

  @override
  Widget buildView(BuildContext context) {
    assert(() {
      /// Highlights UI while debugging.
      debugPaint.debugPaintSizeEnabled = debugPaintSizeEnabled ?? false;
      debugPaint.debugPaintBaselinesEnabled =
          debugPaintBaselinesEnabled ?? false;
      debugPaint.debugPaintPointersEnabled = debugPaintPointersEnabled ?? false;
      debugPaint.debugPaintLayerBordersEnabled =
          debugPaintLayerBordersEnabled ?? false;
      debugPaint.debugRepaintRainbowEnabled =
          debugRepaintRainbowEnabled ?? false;
      return true;
    }());
    if (useCupertino ||
        (Platform.isIOS && !switchUI) ||
        (Platform.isAndroid && switchUI)) {
      return CupertinoApp(
        key: key ?? App.materialKey,
        navigatorKey: navigatorKey ?? onNavigatorKey(),
        home: home,
        routes: routes ?? onRoutes(),
        initialRoute: initialRoute ?? onInitialRoute(),
        onGenerateRoute: onGenerateRoute ?? onOnGenerateRoute(),
        onUnknownRoute: onUnknownRoute ?? onOnUnknownRoute(),
        navigatorObservers: navigatorObservers ?? onNavigatorObservers(),
        builder: builder ?? onBuilder(),
        title: title ?? onTitle(),
        onGenerateTitle: onGenerateTitle ?? onOnGenerateTitle(context),
        color: color ?? onColor(),
        theme: iOSTheme ?? oniOSTheme(),
        locale: locale ?? onLocale(),
        localizationsDelegates:
            localizationsDelegates ?? onLocalizationsDelegates(),
        localeListResolutionCallback:
            localeListResolutionCallback ?? onLocaleListResolutionCallback(),
        localeResolutionCallback:
            localeResolutionCallback ?? onLocaleResolutionCallback(),
        supportedLocales: supportedLocales ??
            onSupportedLocales() ??
            const <Locale>[Locale('en', 'US')],
        showPerformanceOverlay:
            showPerformanceOverlay ?? onShowPerformanceOverlay() ?? false,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages ??
            onCheckerboardRasterCacheImages() ??
            false,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers ??
            onCheckerboardOffscreenLayers() ??
            false,
        showSemanticsDebugger:
            showSemanticsDebugger ?? onShowSemanticsDebugger() ?? false,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner ??
            onDebugShowCheckedModeBanner() ??
            true,
      );
    } else {
      return MaterialApp(
        key: key ?? App.materialKey,
        navigatorKey: navigatorKey ?? onNavigatorKey(),
        home: home,
        routes: routes ?? onRoutes(),
        initialRoute: initialRoute ?? onInitialRoute(),
        onGenerateRoute: onGenerateRoute ?? onOnGenerateRoute(),
        onUnknownRoute: onUnknownRoute ?? onOnUnknownRoute(),
        navigatorObservers: navigatorObservers ?? onNavigatorObservers(),
        builder: builder ?? onBuilder(),
        title: title ?? onTitle(),
        onGenerateTitle: onGenerateTitle ?? onOnGenerateTitle(context),
        color: color ?? onColor(),
        theme: theme ?? onTheme(),
        darkTheme: darkTheme ?? onDarkTheme(),
        themeMode: themeMode ?? onThemeMode(),
        locale: locale ?? onLocale(),
        localizationsDelegates:
            localizationsDelegates ?? onLocalizationsDelegates(),
        localeListResolutionCallback:
            localeListResolutionCallback ?? onLocaleListResolutionCallback(),
        localeResolutionCallback:
            localeResolutionCallback ?? onLocaleResolutionCallback(),
        supportedLocales: supportedLocales ??
            onSupportedLocales() ??
            const <Locale>[Locale('en', 'US')],
        debugShowMaterialGrid:
            debugShowMaterialGrid ?? onDebugShowMaterialGrid() ?? false,
        showPerformanceOverlay:
            showPerformanceOverlay ?? onShowPerformanceOverlay() ?? false,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages ??
            onCheckerboardRasterCacheImages() ??
            false,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers ??
            onCheckerboardOffscreenLayers() ??
            false,
        showSemanticsDebugger:
            showSemanticsDebugger ?? onShowSemanticsDebugger() ?? false,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner ??
            onDebugShowCheckedModeBanner() ??
            true,
      );
    }
  }

  @override
  void dispose() {
    _navigatorKey = null;
    super.dispose();
  }

  /// Override to supply some error handling when starting up.
  @override
  void onError(FlutterErrorDetails details) {
    super.onError(details);
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  @mustCallSuper
  @override
  void reassemble() {
    App.hotLoad = true;
    super.reassemble();
  }

  GlobalKey<NavigatorState> onNavigatorKey() {
    _navigatorKey ??= GlobalKey<NavigatorState>();
    return _navigatorKey;
  }

  GlobalKey<NavigatorState> _navigatorKey;

  Map<String, WidgetBuilder> onRoutes() => const <String, WidgetBuilder>{};
  String onInitialRoute() => null;
  RouteFactory onOnGenerateRoute() => null;
  RouteFactory onOnUnknownRoute() => null;
  List<NavigatorObserver> onNavigatorObservers() => const <NavigatorObserver>[];
  TransitionBuilder onBuilder() => null;
  String onTitle() => '';
  GenerateAppTitle onOnGenerateTitle(BuildContext context) => null;
  Color onColor() => null;
  ThemeData onTheme() => App.theme;
  CupertinoThemeData oniOSTheme() => App.iOSTheme;
  ThemeData onDarkTheme() => null;
  ThemeMode onThemeMode() => ThemeMode.system;
  Locale onLocale() => null;
  Iterable<LocalizationsDelegate<dynamic>> onLocalizationsDelegates() => null;
  LocaleListResolutionCallback onLocaleListResolutionCallback() => null;
  LocaleResolutionCallback onLocaleResolutionCallback() => null;
  Iterable<Locale> onSupportedLocales() => const <Locale>[Locale('en', 'US')];
  bool onDebugShowMaterialGrid() => false;
  bool onShowPerformanceOverlay() => false;
  bool onCheckerboardRasterCacheImages() => false;
  bool onCheckerboardOffscreenLayers() => false;
  bool onShowSemanticsDebugger() => false;
  bool onDebugShowCheckedModeBanner() => true;
}

abstract class AppViewState<T extends StatefulWidget> extends mvc.ViewMVC<T> {
  AppViewState({
    this.con,
    this.controllers,
    this.navigatorKey,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers: const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales,
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = true,
    this.debugPaintSizeEnabled = false,
    this.debugPaintBaselinesEnabled = false,
    this.debugPaintPointersEnabled = false,
    this.debugPaintLayerBordersEnabled = false,
    this.debugRepaintRainbowEnabled = false,
    ErrorWidgetBuilder errorScreen,
  }) : super(
            controller: con,
            controllers: controllers,
            errorScreen: errorScreen);

  final AppController con;
  final List<ControllerMVC> controllers;

  GlobalKey<NavigatorState> navigatorKey;
  Map<String, WidgetBuilder> routes;
  String initialRoute;
  RouteFactory onGenerateRoute;
  RouteFactory onUnknownRoute;
  List<NavigatorObserver> navigatorObservers;
  TransitionBuilder builder;
  String title;
  GenerateAppTitle onGenerateTitle;
  ThemeData theme;
  CupertinoThemeData iOSTheme;
  ThemeData darkTheme;
  ThemeMode themeMode;
  Color color;
  Locale locale;
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  LocaleListResolutionCallback localeListResolutionCallback;
  LocaleResolutionCallback localeResolutionCallback;
  Iterable<Locale> supportedLocales;
  bool debugShowMaterialGrid;
  bool showPerformanceOverlay;
  bool checkerboardRasterCacheImages;
  bool checkerboardOffscreenLayers;
  bool showSemanticsDebugger;
  bool debugShowWidgetInspector;
  bool debugShowCheckedModeBanner;

  /// Highlights UI while debugging.
  bool debugPaintSizeEnabled;
  bool debugPaintBaselinesEnabled;
  bool debugPaintPointersEnabled;
  bool debugPaintLayerBordersEnabled;
  bool debugRepaintRainbowEnabled;

  /// Provide 'the view'
  Widget build(BuildContext context);

//  @mustCallSuper
//  Future<bool> init() async {
//    final init = await con?.init() ?? true;
//    return init;
//  }

  @mustCallSuper
  Future<bool> init() => con?.init() ?? Future.value(true);

  @override
  void dispose() {
    object = null;
    super.dispose();
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Text("DRAWER HEADER.."),
        ),
        ListTile(
          title: new Text("Item => 1"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: new Text("Item => 2"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }
}

abstract class ConnectivityListener {
  onConnectivityChanged(ConnectivityResult result);
}

class Controllers {
  static T of<T extends ControllerMVC>([BuildContext context, listen = true]) {
    T con;
    if (context != null && listen)
      con = App._vw?.controllerByType<T>(context, listen);
    return con ??= AppMVC.controllers[_type<T>()];
  }

  static Type _type<T>() => T;
}

class Consumer<T extends ControllerMVC> extends StatelessWidget {
  Consumer({
    Key key,
    @required this.builder,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  /// The builder
  final Widget Function(BuildContext context, T controller, Widget child)
      builder;

  /// The child widget to pass to [builder].
  final Widget child;

  @override
  Widget build(BuildContext context) => SetState(
      builder: (context, object) => builder(
            context,
            Controllers.of<T>(),
            child,
          ));
}

/// Supply an MVC State object that hooks into the App class.
abstract class StateMVC<T extends StatefulWidget> extends mvc.StateMVC<T>
    with ErrorHandler {
  //
  StateMVC([ControllerMVC controller]) : super(controller);

  @override
  void refresh() {
    if (mounted) {
      super.refresh();
      App.refresh();
    }
  }
}
