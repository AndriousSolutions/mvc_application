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

import 'dart:async' show Future, StreamSubscription;

import 'package:flutter/foundation.dart'
    show
        Key,
        mustCallSuper,
        protected;

import 'package:flutter/material.dart'
    show
        StatefulWidget,
        AppLifecycleState,
        BoxDecoration,
        BuildContext,
        Color,
        Drawer,
        DrawerHeader,
        FutureBuilder,
        GenerateAppTitle,
        GlobalKey,
        Key,
        ListTile,
        ListView,
        Locale,
        LocaleResolutionCallback,
        LocalizationsDelegate,
        MaterialApp,
        Navigator,
        NavigatorObserver,
        NavigatorState,
        RouteFactory,
        Scaffold,
        ScaffoldState,
        State,
        StatelessWidget,
        Text,
        Theme,
        ThemeData,
        TransitionBuilder,
        Widget,
        WidgetBuilder,
        mustCallSuper,
        protected;

import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;

import 'package:mvc_application/app.dart' show AppMVC, AppConMVC;

import 'package:mvc_application/controller.dart' show ControllerMVC;

import 'package:mvc_application/view.dart' show LoadingScreen, StateMVC;

import 'package:file_utils/files.dart' show Files;

import 'package:file_utils/InstallFile.dart' show InstallFile;

import 'package:prefs/prefs.dart' show Prefs;

import 'package:assets/assets.dart' show Assets;

import 'package:flutter/widgets.dart'
    show
        AppLifecycleState,
        BoxDecoration,
        BuildContext,
        Color,
        FutureBuilder,
        GenerateAppTitle,
        GlobalKey,
        Key,
        ListView,
        Locale,
        LocaleResolutionCallback,
        LocalizationsDelegate,
        Navigator,
        NavigatorObserver,
        NavigatorState,
        RouteFactory,
        State,
        StatelessWidget,
        Text,
        TransitionBuilder,
        Widget,
        WidgetBuilder,
        mustCallSuper,
        protected;

import 'package:mvc_application/src/view/utils/loading_screen.dart'
    show LoadingScreen;

/// Highlights UI while debugging.
import 'package:flutter/rendering.dart' as debugPaint;

/// High-level function to highlights UI while debugging.
void _debugPaint({
  bool debugPaintSizeEnabled = false,
  bool debugPaintBaselinesEnabled = false,
  bool debugPaintPointersEnabled = false,
  bool debugPaintLayerBordersEnabled = false,
  bool debugRepaintRainbowEnabled = false,
}) {
  /// Highlights UI while debugging.
  debugPaint.debugPaintSizeEnabled = debugPaintSizeEnabled;
  debugPaint.debugPaintBaselinesEnabled = debugPaintBaselinesEnabled;
  debugPaint.debugPaintPointersEnabled = debugPaintPointersEnabled;
  debugPaint.debugPaintLayerBordersEnabled = debugPaintLayerBordersEnabled;
  debugPaint.debugRepaintRainbowEnabled = debugRepaintRainbowEnabled;
}

/// Auth and Firebase must be in a separate class for now.
//import 'package:auth/auth.dart' show Auth;

//import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;

//import 'package:firebase/firebase.dart' show FireBase;

class App extends StatelessWidget {
  /// All is static
  factory App(AppView view, {AppConMVC con, Key key}) {
    if (_this == null) _this = App._(view, con, key);
    return _this;
  }

  /// Make only one instance of this class.
  static App _this;

  App._(AppView view, AppConMVC con, Key key) : super(key: key) {
    _vw = view;
    _app = _App(con: con);
  }

  static _App _app;

  /// Needs to be static for the getters below.
  static AppView _vw;

  static GlobalKey<NavigatorState> get navigatorKey => _vw.navigatorKey;
  static Map<String, WidgetBuilder> get routes => _vw.routes;
  static String get initialRoute => _vw.initialRoute;
  static RouteFactory get onGenerateRoute => _vw.onGenerateRoute;
  static RouteFactory get onUnknownRoute => _vw.onUnknownRoute;
  static List<NavigatorObserver> get navigatorObservers =>
      _vw.navigatorObservers;
  static TransitionBuilder get builder => _vw.builder;
  static String get title => _vw.title;
  static GenerateAppTitle get onGenerateTitle => _vw.onGenerateTitle;
  static ThemeData get theme => _vw.theme ?? App._getTheme();
  static Color get color => _vw.color;
  static Locale get locale => _vw.locale;
  static Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _vw.localizationsDelegates;
  static LocaleResolutionCallback get localeResolutionCallback =>
      _vw.localeResolutionCallback;
  static Iterable<Locale> get supportedLocales => _vw.supportedLocales;
  static bool get debugShowMaterialGrid => _vw.debugShowMaterialGrid;
  static bool get showPerformanceOverlay => _vw.showPerformanceOverlay;
  static bool get checkerboardRasterCacheImages =>
      _vw.checkerboardRasterCacheImages;
  static bool get checkerboardOffscreenLayers =>
      _vw.checkerboardOffscreenLayers;
  static bool get showSemanticsDebugger => _vw.showSemanticsDebugger;
  static bool get debugShowCheckedModeBanner => _vw.debugShowCheckedModeBanner;

  static BuildContext get context => _context;
  static BuildContext _context;

  static ThemeData _theme;

  static ScaffoldState _scaffold;

  @override
  Widget build(BuildContext context) {
    Assets.init(context);
    _context = context;
    return MaterialApp(
      key: key,
      navigatorKey: _vw.navigatorKey,
      routes: _vw.routes ?? const <String, WidgetBuilder>{},
      initialRoute: _vw.initialRoute,
      onGenerateRoute: _vw.onGenerateRoute,
      onUnknownRoute: _vw.onUnknownRoute,
      navigatorObservers: _vw.navigatorObservers ?? const <NavigatorObserver>[],
      builder: _vw.builder,
      title: _vw.title,
      onGenerateTitle: _vw.onGenerateTitle,
      color: _vw.color,
      theme: _vw.theme ?? _App.getThemeData(),
      locale: _vw.locale,
      localizationsDelegates: _vw.localizationsDelegates,
      localeResolutionCallback: _vw.localeResolutionCallback,
      supportedLocales:
          _vw.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      debugShowMaterialGrid: _vw.debugShowMaterialGrid ?? false,
      showPerformanceOverlay: _vw.showPerformanceOverlay ?? false,
      checkerboardRasterCacheImages: _vw.checkerboardRasterCacheImages ?? false,
      checkerboardOffscreenLayers: _vw.checkerboardOffscreenLayers ?? false,
      showSemanticsDebugger: _vw.showSemanticsDebugger ?? false,
      debugShowCheckedModeBanner: _vw.debugShowCheckedModeBanner ?? true,
      home: FutureBuilder(
        future: _app.init(),
        builder: (_, snapshot) {
          return snapshot.hasData ? _app : LoadingScreen();
        },
      ),
    );
  }

  /// Called in the _App dispose() function.
  static void dispose() {
    _context = null;
    _theme = null;
    _scaffold = null;
  }

  static Future<String> getInstallNum() => _App.getInstallNum();
  static bool get isOnline => _App.isOnline;
  static String get installNum => _App.installNum;
  static addConnectivityListener(ConnectivityListener listener) =>
      _App.addConnectivityListener(listener);
  static removeConnectivityListener(ConnectivityListener listener) =>
      _App.removeConnectivityListener(listener);
  static clearConnectivityListener() => _App.clearConnectivityListener();

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static ThemeData _getTheme() {
    if (_theme == null) _theme = Theme.of(_context);
    return _theme;
  }

  static ScaffoldState get scaffold => App._getScaffold();
  static ScaffoldState _getScaffold() {
    if (_scaffold == null) _scaffold = Scaffold.of(_context, nullOk: true);
    return _scaffold;
  }
}


class _App extends AppMVC {
  factory _App({AppConMVC con, Key key}) {
    if (_this == null) _this = _App._(con: con, key: key);
    return _this;
  }
  static _App _this;

  _App._({AppConMVC con, Key key})
      : _vw = App._vw,
        _state = App._vw,
        super(con: con, key: key);

  final AppView _vw;
  final State _state;

  @override
  @protected
  Widget build(BuildContext context) => _ViewWidget(_state);

  /// Called in the State object's dispose() function.
  void dispose() {
    _vw.dispose();
    _connectivitySubscription.cancel();
    _connectivitySubscription = null;
    App.dispose();
    super.dispose();
  }

  Future<bool> init() async {
    super.init();
    _initInternal();
    return _vw.init();
  }

  static getThemeData() {
    Prefs.getStringF('theme').then((value) {
      var theme = value ?? 'light';
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
    });
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
  static String _path;
  static get filesDir => _path;
  static String _connectivityStatus;
  static String get connectivity => _connectivityStatus;
  static bool get isOnline => _connectivityStatus != 'none';
  static Set _listeners = new Set();
  static Future<String> getInstallNum() => InstallFile.id();
  static String get installNum =>
      _installNum ??
      App.getInstallNum().then((id) {
        _installNum = id;
      }).catchError((e) {
        _installNum = '';
      });
  static String _installNum;

  /// Internal Initialization routines.
  static void _initInternal() {
    /// Get the installation number
    InstallFile.id().then((id) {
      _installNum = id;
    }).catchError((e) {});

    /// Determine the location to the files directory.
    Files.localPath.then((path) {
      _path = path;
    }).catchError((e) {});

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

  static addConnectivityListener(ConnectivityListener listener) =>
      _listeners.add(listener);

  static removeConnectivityListener(ConnectivityListener listener) =>
      _listeners.remove(listener);

  static clearConnectivityListener() => _listeners.clear();
}

class _ViewWidget extends StatefulWidget {
  _ViewWidget(this.state);
  final StateMVC state;
  @override
  @protected
  State createState() => state;
}

abstract class AppView extends StateMVC {
  AppView({
    this.controller,
    this.navigatorKey,
    this.routes: const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers: const <NavigatorObserver>[],
    this.builder,
    this.title: '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.supportedLocales: const <Locale>[const Locale('en', 'US')],
    this.debugShowMaterialGrid: false,
    this.showPerformanceOverlay: false,
    this.checkerboardRasterCacheImages: false,
    this.checkerboardOffscreenLayers: false,
    this.showSemanticsDebugger: false,
    this.debugShowCheckedModeBanner: true,
    this.debugPaintSizeEnabled = false,
    this.debugPaintBaselinesEnabled = false,
    this.debugPaintPointersEnabled = false,
    this.debugPaintLayerBordersEnabled = false,
    this.debugRepaintRainbowEnabled = false,
  }) : super(controller) {
    /// Highlights UI while debugging.
    _debugPaint(
      debugPaintSizeEnabled: debugPaintSizeEnabled,
      debugPaintBaselinesEnabled: debugPaintBaselinesEnabled,
      debugPaintPointersEnabled: debugPaintPointersEnabled,
      debugPaintLayerBordersEnabled: debugPaintLayerBordersEnabled,
      debugRepaintRainbowEnabled: debugRepaintRainbowEnabled,
    );
  }

  final AppController controller;

  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final RouteFactory onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder builder;
  final String title;
  final GenerateAppTitle onGenerateTitle;
  final ThemeData theme;
  final Color color;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final LocaleResolutionCallback localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  /// Highlights UI while debugging.
  final bool debugPaintSizeEnabled;
  final bool debugPaintBaselinesEnabled;
  final bool debugPaintPointersEnabled;
  final bool debugPaintLayerBordersEnabled;
  final bool debugRepaintRainbowEnabled;

  @mustCallSuper
  Future<bool> init() {
    return controller.init();
  }

  /// Override to dispose anything initialized in your init() function.
  @mustCallSuper
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Provide 'the view'
  Widget build(BuildContext context);
}

class AppController extends ControllerMVC {
  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the _App.init() function.
  @mustCallSuper
  Future<bool> init() async {
//    Auth.init(listener: listener);
    Prefs.init();
    return Future.value(true);
  }

  /// Ensure certain objects are 'disposed.'
  /// Callec by the AppState.dispose() function.
  @override
  @mustCallSuper
  void dispose() {
//    Auth.dispose();
    Prefs.dispose();
    /// Assets.init(context); called in App.build() -gp
    Assets.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
//    _App.didChangeAppLifecycleState(state);
  }

//  /// Authentication listener
//  listener(FirebaseUser user){
//    if (user != null) {
//      var isAnonymous = user.isAnonymous;
//      var uid = user.uid;
////      print(
////          'In FirestoreServices, isAnonymous = $isAnonymous and uid = $uid');
//    }
//  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Text("DRAWER HEADER.."),
          decoration: new BoxDecoration(),
        ),
        new ListTile(
          title: new Text("Item => 1"),
          onTap: () {
            Navigator.pop(context);
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => new FirstPage()));
          },
        ),
        new ListTile(
          title: new Text("Item => 2"),
          onTap: () {
            Navigator.pop(context);
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => new SecondPage()));
          },
        ),
      ],
    ));
  }
}

abstract class ConnectivityListener {
  onConnectivityChanged(ConnectivityResult result);
}