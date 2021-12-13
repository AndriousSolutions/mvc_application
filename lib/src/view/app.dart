///
/// Copyright (C) 2019 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  09 Feb 2019
///
///

import 'dart:async' show Future, StreamSubscription;

// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

import 'package:flutter/foundation.dart' show FlutterExceptionHandler, kIsWeb;

import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_application/model.dart';

import 'package:mvc_application/view.dart' as v;

import 'package:mvc_application/controller.dart'
    show ControllerMVC, DeviceInfo, HandleError;

/// This class is available throughout the app
/// Readily supply properties about the App.
class App {
  //
  factory App({
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
    bool allowNewHandlers = true,
  }) =>
      _this ??= App._(errorHandler, errorScreen, errorReport, allowNewHandlers);

  App._(
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
    bool allowNewHandlers,
  ) {
    _errorHandler = v.AppErrorHandler(
      handler: errorHandler,
      builder: errorScreen,
      report: errorReport,
      allowNewHandlers: allowNewHandlers,
    );
  }
  static App? _this;

  static v.AppErrorHandler? get errorHandler => _errorHandler;
  static v.AppErrorHandler? _errorHandler;

  /// Dispose the App properties.
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _packageInfo = null;
    _themeData = null;
    _appWidget = null;
    _appState = null;
    // Restore the original error handling.
    _errorHandler!.dispose();
    _errorHandler = null;
  }

  /// Assign the AppStateful object
  bool setAppStatefulWidget(v.AppStatefulWidget? appWidget) {
    // Reassign with every StatefulWidget re-created.
    _appWidget = appWidget;
    return appWidget != null;
  }

  static v.AppStatefulWidget? _appWidget;

  /// Assign the class with the AppState object.
  bool setAppState(v.AppState? vw) {
    final set = _appState == null && vw != null;
    if (set) {
      // Only assigned once with the first call.
      _appState ??= vw;
      // Assign the 'app' object to the app's view
      vw!.app = this;
    }
    return set;
  }

  /// The App State object.
  static v.AppState? get vw => _appState;
  //todo: Change to 'late' instead and redo everything reference.
  static v.AppState? _appState;

  /// App-level error handling.
  static void onError(FlutterErrorDetails details) {
    // Call the App's 'current' error handler.
    final handler = errorHandler?.flutterExceptionHandler;
    if (handler != null) {
      handler(details);
    } else {
      // Call Flutter's default error handler.
      FlutterError.presentError(details);
    }
  }

  /// App-level error handling if async operation at start up fails
  void onAsyncError(AsyncSnapshot<bool> snapshot) {
    final dynamic exception = snapshot.error;
    final details = FlutterErrorDetails(
      exception: exception,
      stack: exception is Error ? exception.stackTrace : null,
      library: 'app_statefulwidget',
      context: ErrorDescription('while getting ready with FutureBuilder Async'),
    );
    onError(details);
  }

  /// Collect the device's information.
  static Future<void> getDeviceInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    // Collect Device Information
    await DeviceInfo.init();
  }

  /// More efficient widget tree rebuilds
  static final widgetsAppKey = GlobalKey();

  /// Determine if the App initialized successfully.
  // ignore: unnecessary_getters_setters
  static bool? get isInit => _isInit;

  /// Set the init only once.
  // ignore: unnecessary_getters_setters
  static set isInit(bool? init) => _isInit ??= init;
  static bool? _isInit;

  /// Flag to set hot reload from now on.
  // ignore: unnecessary_getters_setters
  static bool get hotReload => _hotReload;

  /// Once set, it will always hot reload.
  // ignore: unnecessary_getters_setters
  static set hotReload(bool hotReload) {
    // It doesn't accept false.
    // i.e. Once true, it stays true.
    if (!hotReload) {
      return;
    }
    _hotReload = hotReload;
  }

  static bool _hotReload = false;

  // Use Material UI when explicitly specified or even when running in iOS
  /// Indicates if the App is running the Material interface theme.
  static bool get useMaterial =>
      (_appState != null && _appState!.useMaterial!) ||
      (UniversalPlatform.isAndroid &&
          (_appState == null || !_appState!.switchUI!)) ||
      (UniversalPlatform.isIOS && (_appState == null || _appState!.switchUI!));

  // Use Cupertino UI when explicitly specified or even when running in Android
  /// Indicates if the App is running the Cupertino interface theme.
  static bool get useCupertino =>
      (_appState != null && _appState!.useCupertino!) ||
      (UniversalPlatform.isIOS &&
          (_appState == null || !_appState!.switchUI!)) ||
      (UniversalPlatform.isAndroid &&
          (_appState == null || _appState!.switchUI!));

  /// Explicitly change to a particular interface.
  static void changeUI(String ui) {
    _appState?.changeUI(ui);
    refresh();
  }

  /// Return the navigator key used by the App's View.
  static GlobalKey<NavigatorState>? get navigatorKey => _appState?.navigatorKey;
  static set navigatorKey(GlobalKey<NavigatorState>? v) {
    if (v != null) {
      _appState?.navigatorKey = v;
    }
  }

  /// Return the navigator key used by the App's View.
  static GlobalKey<ScaffoldMessengerState>? get scaffoldMessengerKey =>
      _appState?.scaffoldMessengerKey;
  static set scaffoldMessengerKey(GlobalKey<ScaffoldMessengerState>? v) {
    if (v != null) {
      _appState?.scaffoldMessengerKey = v;
    }
  }

  /// Returns the routes used by the App's View.
  static Map<String, WidgetBuilder>? get routes => _appState?.routes;
  static set routes(Map<String, WidgetBuilder>? v) {
    if (v != null) {
      _appState?.routes = v;
    }
  }

  /// Returns to the initial route used by the App's View.
  static String? get initialRoute => _appState?.initialRoute;
  static set initialRoute(String? v) {
    if (v != null) {
      _appState?.initialRoute = v;
    }
  }

  /// The route generator used when the app is navigated to a named route.
  static RouteFactory? get onGenerateRoute => _appState?.onGenerateRoute;
  static set onGenerateRoute(RouteFactory? v) {
    if (v != null) {
      _appState?.onGenerateRoute = v;
    }
  }

  /// Called when [onGenerateRoute] fails except for the [initialRoute].
  static RouteFactory? get onUnknownRoute => _appState?.onUnknownRoute;
  static set onUnknownRoute(RouteFactory? v) {
    if (v != null) {
      _appState?.onUnknownRoute = v;
    }
  }

  /// The list of observers for the [Navigator] for this app.
  static List<NavigatorObserver>? get navigatorObservers =>
      _appState?.navigatorObservers;
  static set navigatorObservers(List<NavigatorObserver>? v) {
    if (v != null) {
      _appState?.navigatorObservers = v;
    }
  }

  /// if neither [routes], or [onGenerateRoute] was passed.
  static TransitionBuilder? get builder => _appState?.builder;
  static set builder(TransitionBuilder? v) {
    if (v != null) {
      _appState?.builder = v;
    }
  }

  /// Returns the title for the App's View.
  static String? get title => _appState?.title;
  static set title(String? v) {
    if (v != null) {
      _appState?.title = v;
    }
  }

  /// Routine used to generate the App's title.
  static GenerateAppTitle? get onGenerateTitle => _appState?.onGenerateTitle;
  static set onGenerateTitle(GenerateAppTitle? v) {
    if (v != null) {
      _appState?.onGenerateTitle = v;
    }
  }

  // Allow it to be assigned null.
  /// The App's current Material theme.
  static ThemeData? get themeData => _themeData;
  static set themeData(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is ThemeData) {
      _themeData = value;
    } else if (value is CupertinoThemeData) {
      // Ignore the value
    } else if (value is! ColorSwatch) {
      // Ignore the value
    } else if (_themeData == null) {
      _themeData = ThemeData(
        primaryColor: value,
      );
    } else {
      _themeData = _themeData?.copyWith(
        primaryColor: value,
      );
    }
  }

  static ThemeData? _themeData;

  /// The Apps's current Cupertino theme.
  static CupertinoThemeData? get iOSTheme => _iOSTheme;
  static CupertinoThemeData? _iOSTheme;
  static set iOSTheme(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is CupertinoThemeData) {
      _iOSTheme = value;
    } else if (value is ThemeData) {
      _iOSTheme = MaterialBasedCupertinoThemeData(materialTheme: value);
    } else if (value is! ColorSwatch) {
      // Ignore the value
    } else if (_iOSTheme == null) {
      _iOSTheme = CupertinoThemeData(
        primaryColor: value,
      );
    } else {
      _iOSTheme = _iOSTheme?.copyWith(
        primaryColor: value,
      );
    }
  }

  static ColorSwatch<int?>? setThemeData([ColorSwatch<int?>? value]) {
    //
    if (value != null) {
      Prefs.setInt(
        'colorTheme',
        Colors.primaries.indexOf(value as MaterialColor),
      );
    } else {
      final swatch = Prefs.getInt('colorTheme', -1);
      // If never set in the first place, ignore
      if (swatch > -1) {
        value = Colors.primaries[swatch];
      }
    }

    if (value != null) {
      /// Assign the colour to the floating button as well.
      themeData = ThemeData(
        primarySwatch: value as MaterialColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: value,
        ),
      );
      iOSTheme = value;
    }
    return value;
  }

  /// Returns the Color passed to the App's View.
  static Color? get color => _appState?.color;
  static set color(Color? v) {
    if (v != null) {
      _appState?.color = v;
    }
  }

  /// Returns the App's current locale.
  static Locale? get locale =>
      _appState?.locale ??= Localizations.maybeLocaleOf(context!) ??
          _resolveLocales(
            WidgetsBinding.instance!.window.locales,
            _appState?.supportedLocales,
          );
  static set locale(Locale? v) {
    if (v != null) {
      _appState?.locale = v;
    }
  }

  /// Determine the locale used by the Mobile phone.
  static Locale? _resolveLocales(
    List<Locale>? preferredLocales,
    Iterable<Locale>? supportedLocales,
  ) {
    // Attempt to use localeListResolutionCallback.
    if (_appState?.localeListResolutionCallback != null) {
      final locales = _appState?.supportedLocales;
      final locale =
          _appState?.localeListResolutionCallback!(preferredLocales, locales!);
      if (locale != null) {
        return locale;
      }
    }

    final preferred = preferredLocales != null && preferredLocales.isNotEmpty
        ? preferredLocales.first
        : null;

    // localeListResolutionCallback failed, falling back to localeResolutionCallback.
    if (_appState?.localeResolutionCallback != null) {
      final locales = _appState?.supportedLocales;
      final locale = _appState?.localeResolutionCallback!(
        preferred,
        locales!,
      );
      if (locale != null) {
        return locale;
      }
    }
    // Both callbacks failed, falling back to default algorithm.
//    return basicLocaleListResolution(preferredLocales, supportedLocales);
    return preferred;
  }

  /// Returns the App's current localizations delegates.
  static Iterable<LocalizationsDelegate<dynamic>>? get localizationsDelegates =>
      _appState?.localizationsDelegates;
  static set localizationsDelegates(
      Iterable<LocalizationsDelegate<dynamic>>? v) {
    if (v != null) {
      _appState?.localizationsDelegates = v;
    }
  }

  /// Resolves the App's locale.
  static LocaleResolutionCallback? get localeResolutionCallback =>
      _appState?.localeResolutionCallback;
  static set localeResolutionCallback(LocaleResolutionCallback? v) {
    if (v != null) {
      _appState?.localeResolutionCallback = v;
    }
  }

  /// Returns an iteration of the App's locales.
  static Iterable<Locale>? get supportedLocales => _appState?.supportedLocales;
  static set supportedLocales(Iterable<Locale>? v) {
    if (v != null) {
      _appState?.supportedLocales = v;
    }
  }

  /// If true, it paints a grid overlay on Material apps.
  static bool? get debugShowMaterialGrid => _appState?.debugShowMaterialGrid;
  static set debugShowMaterialGrid(bool? v) {
    if (v != null) {
      _appState?.debugShowMaterialGrid = v;
    }
  }

  /// If true, it turns on a performance overlay.
  static bool? get showPerformanceOverlay => _appState?.showPerformanceOverlay;
  static set showPerformanceOverlay(bool? v) {
    if (v != null) {
      _appState?.showPerformanceOverlay = v;
    }
  }

  /// Checkerboard raster cache to speed up overall rendering.
  static bool? get checkerboardRasterCacheImages =>
      _appState?.checkerboardRasterCacheImages;
  static set checkerboardRasterCacheImages(bool? v) {
    if (v != null) {
      _appState?.checkerboardRasterCacheImages = v;
    }
  }

  /// Checkerboard layers rendered offscreen bitmaps.
  static bool? get checkerboardOffscreenLayers =>
      _appState?.checkerboardOffscreenLayers;
  static set checkerboardOffscreenLayers(bool? v) {
    if (v != null) {
      _appState?.checkerboardOffscreenLayers = v;
    }
  }

  /// Shows an overlay of accessibility information
  static bool? get showSemanticsDebugger => _appState?.showSemanticsDebugger;
  static set showSemanticsDebugger(bool? v) {
    if (v != null) {
      _appState?.showSemanticsDebugger = v;
    }
  }

  /// Shows a little "DEBUG" banner in checked mode.
  static bool? get debugShowCheckedModeBanner =>
      _appState?.debugShowCheckedModeBanner;
  static set debugShowCheckedModeBanner(bool? v) {
    if (v != null) {
      _appState?.debugShowCheckedModeBanner = v;
    }
  }

  /// Each RenderBox to paint a box around its bounds.
  static bool? get debugPaintSizeEnabled => _appState?.debugPaintSizeEnabled;
  static set debugPaintSizeEnabled(bool? v) {
    if (v != null) {
      _appState?.debugPaintSizeEnabled = v;
    }
  }

  /// RenderBox paints a line at its baselines.
  static bool? get debugPaintBaselinesEnabled =>
      _appState?.debugPaintBaselinesEnabled;
  static set debugPaintBaselinesEnabled(bool? v) {
    if (v != null) {
      _appState?.debugPaintBaselinesEnabled = v;
    }
  }

  /// Objects flash while they are being tapped.
  static bool? get debugPaintPointersEnabled =>
      _appState?.debugPaintPointersEnabled;
  static set debugPaintPointersEnabled(bool? v) {
    if (v != null) {
      _appState?.debugPaintPointersEnabled = v;
    }
  }

  /// Layer paints a box around its bound.
  static bool? get debugPaintLayerBordersEnabled =>
      _appState?.debugPaintLayerBordersEnabled;
  static set debugPaintLayerBordersEnabled(bool? v) {
    if (v != null) {
      _appState?.debugPaintLayerBordersEnabled = v;
    }
  }

  /// Overlay a rotating set of colors when repainting layers in checked mode.
  static bool? get debugRepaintRainbowEnabled =>
      _appState?.debugRepaintRainbowEnabled;
  static set debugRepaintRainbowEnabled(bool? v) {
    if (v != null) {
      _appState?.debugRepaintRainbowEnabled = v;
    }
  }

  /// The running platform
  static TargetPlatform? get platform {
    if (_platform == null && context != null) {
      _platform = Theme.of(context!).platform;
    }
    return _platform;
  }

  static TargetPlatform? _platform;

  // Application information
  static PackageInfo? _packageInfo;

  /// The Name of the App.
  static String? get appName => _packageInfo?.appName;

  /// The 'Package Name' of the App.
  static String? get packageName => _packageInfo?.packageName;

  /// The current version of the App.
  static String? get version => _packageInfo?.version;

  /// The build number of the App.
  static String? get buildNumber => _packageInfo?.buildNumber;

  /// Determines if running in an IDE or in production.
  static bool get inDebugger => v.AppStatefulWidgetMVC.inDebugger;

  /// Refresh the root State object, AppView.
  static void refresh() => _appState?.refresh();

  /// Display the SnackBar
  static void snackBar({
    Key? key,
    required Widget content,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    Duration? duration,
    Animation<double>? animation,
    VoidCallback? onVisible,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    final state = ScaffoldMessenger.maybeOf(context!);
    state?.showSnackBar(
      SnackBar(
        key: key,
        content: content,
        backgroundColor: backgroundColor,
        elevation: elevation,
        margin: margin,
        padding: padding,
        width: width,
        shape: shape,
        behavior: behavior,
        action: action,
        duration: duration ?? const Duration(milliseconds: 4000),
        animation: animation,
        onVisible: onVisible,
        dismissDirection: dismissDirection,
      ),
    );
  }

  /// Catch and explicitly handle the error.
  static void catchError(Object ex) {
    if (ex is! Exception) {
      ex = Exception(ex.toString());
    }
    _appState?.catchError(ex);
  }

  /// The BuildContext for the App's View.
  static BuildContext? get context => _appWidget?.context;

  /// The Scaffold object for this App's View.
  static ScaffoldState get scaffold => Scaffold.of(context!);
  // 'maybeOf' only in Beta channel
//  static ScaffoldState get scaffold => Scaffold.maybeOf(context);

  /// The Physical width of the screen
  static double get screenPhysicalWidth {
    final media = MediaQuery.of(context!);
    return media.size.width * media.devicePixelRatio;
  }

  /// The logical width of the screen
  static double get screenWidth => MediaQuery.of(context!).size.width;

  /// The Physical height of the screen
  static double get screenPhysicalHeight => MediaQuery.of(context!).size.height;

  /// The Logical height of the screen
  static double get screenHeight {
    final media = MediaQuery.of(context!);
    return media.size.height -
        media.padding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight;
  }

  /// Screen Size
  static Size get screenSize => MediaQuery.of(context!).size;

  /// Set whether the app is to use a 'small screen' or not.
  /// Determine if running on a desktop or on a phone or tablet
  static bool get asSmallScreen => App.inDebugger && false;

  /// Return the bool value indicating if running in a small screen or not.
  static bool get inSmallScreen {
    bool smallScreen;

    // May be manually assigned.
    smallScreen = asSmallScreen;

    if (!smallScreen) {
      smallScreen = screenSize.width < 800;
    }
    return smallScreen;
  }

  /// Determine the connectivity.
  static final Connectivity _connectivity = Connectivity();

  static StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// The local directory for this App.
  static String? get filesDir => _path;
  static String? _path;

  /// Returns the connection status of the device.
  static String? get connectivity => _connectivityStatus;
  static String? _connectivityStatus;

  /// Indicates if the app has access to the Internet.
  static bool get isOnline => _connectivityStatus != 'none';

  /// Connectivity listeners.
  static final Set<ConnectivityListener> _listeners = {};

  /// Add a Connectivity listener.
  static bool addConnectivityListener(ConnectivityListener? listener) {
    var add = false;
    if (listener != null) {
      add = _listeners.add(listener);
    }
    return add;
  }

  /// Remove a Connectivity listener.
  static bool removeConnectivityListener(ConnectivityListener? listener) {
    var remove = false;
    if (listener != null) {
      remove = _listeners.remove(listener);
    }
    return remove;
  }

  /// Clear Connectivity listeners.
  static void clearConnectivityListener() => _listeners.clear();

  /// The id for this App's particular installation.
  static Future<String?> getInstallNum() => InstallFile.id();

  /// The id for this App's particular installation.
  static String? get installNum => _installNum;
  static String? _installNum;

  /// Internal Initialization routines.
  Future<void> initInternal() async {
    //
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      for (final listener in _listeners) {
        listener.onConnectivityChanged(result);
      }
    });

    await _initConnectivity().then((status) {
      _connectivityStatus = status;
    }).catchError((e) {
      _connectivityStatus = 'none';
    });

    // If running on the web the rest of the code is incompatible.
    if (kIsWeb) {
      return;
    }

    // Get the installation number
    _installNum = await InstallFile.id();

    // Determine the location to the files directory.
    _path = await Files.localPath;
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

/// A Listener for the device's own connectivity status at any point in time.
mixin ConnectivityListener {
  void onConnectivityChanged(ConnectivityResult result);
}

/// Supply an MVC State object that hooks into the App class.
abstract class StateMVC<T extends StatefulWidget> extends mvc.StateMVC<T>
    with HandleError {
  //
  StateMVC([ControllerMVC? controller]) : super(controller);

  /// Allow access to the static 'of' function
  static T? of<T extends StateMVC>(BuildContext context) =>
      mvc.StateMVC.of<T>(context);

  @override
  void refresh() {
    if (mounted) {
      super.refresh();
      App.refresh();
    }
  }
}

/// A standard Drawer object for your Flutter app.
class AppDrawer extends StatelessWidget {
  AppDrawer({
    Key? key,
    this.elevation,
    this.semanticLabel,
    this.header,
    this.items,
  }) : super(key: key) {
    // Take any defined items.
    if (items != null) {
      _items.addAll(items!);
    }
  }

  final double? elevation;
  final String? semanticLabel;
  final DrawerHeader? header;
  final List<ListTile>? items;
  final List<ListTile> _items = [];

  /// one item
  void add(ListTile? item) {
    if (item != null) {
      _items.add(item);
    }
  }

  /// Add a List
  void addAll(List<ListTile>? items) {
    if (items != null) {
      _items.addAll(items);
    }
  }

  /// Remove an item
  bool remove(ListTile? item) {
    bool remove = item != null;
    if (remove) {
      remove = _items.remove(item);
    }
    return remove;
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    if (header != null) {
      widgets.add(header!);
    }
    if (_items.isNotEmpty) {
      widgets.addAll(_items);
    }
    return Drawer(
        elevation: elevation ?? 16,
        semanticLabel: semanticLabel,
        child: ListView(
          children: widgets,
        ));
  }
}
