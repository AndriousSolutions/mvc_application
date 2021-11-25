///
/// Copyright (C) 2020 Andrious Solutions
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
///          Created  27 Oct 2020
///

// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

import 'package:flutter/foundation.dart' show FlutterExceptionHandler, Key;

import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

import 'package:mvc_application/controller.dart'
    show AppController, ControllerMVC;

import 'package:mvc_application/view.dart' as v
    show App, AppErrorHandler, I10n, I10nDelegate, ReportErrorHandler;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

/// Highlights UI while debugging.
import 'package:flutter/rendering.dart' as debug;

/// The View for the app. The 'look and feel' for the whole app.
class AppState<T extends mvc.AppStatefulWidgetMVC> extends _AppState<T> {
  //
  AppState({
    this.key,
    this.home,
    AppController? con,
    List<ControllerMVC>? controllers,
    Object? object,
    GlobalKey<NavigatorState>? navigatorKey,
    RouteInformationProvider? routeInformationProvider,
    RouteInformationParser<Object>? routeInformationParser,
    RouterDelegate<Object>? routerDelegate,
    BackButtonDispatcher? backButtonDispatcher,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
    Map<String, WidgetBuilder>? routes,
    String? initialRoute,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    List<NavigatorObserver>? navigatorObservers,
    TransitionBuilder? builder,
    String? title,
    GenerateAppTitle? onGenerateTitle,
    ThemeData? theme,
    CupertinoThemeData? iOSTheme,
    ThemeData? darkTheme,
    ThemeMode? themeMode,
    Color? color,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    LocaleListResolutionCallback? localeListResolutionCallback,
    LocaleResolutionCallback? localeResolutionCallback,
    Iterable<Locale>? supportedLocales,
    this.useMaterial,
    this.useCupertino,
    this.switchUI,
    bool? debugShowMaterialGrid,
    bool? showPerformanceOverlay,
    bool? checkerboardRasterCacheImages,
    bool? checkerboardOffscreenLayers,
    bool? showSemanticsDebugger,
    bool? debugShowCheckedModeBanner,
    Map<LogicalKeySet, Intent>? shortcuts,
    Map<Type, Action<Intent>>? actions,
    String? restorationScopeId,
    ScrollBehavior? scrollBehavior,
    bool? debugShowWidgetInspector,
    bool? debugPaintSizeEnabled,
    bool? debugPaintBaselinesEnabled,
    bool? debugPaintPointersEnabled,
    bool? debugPaintLayerBordersEnabled,
    bool? debugRepaintRainbowEnabled,
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
    this.inHome,
    this.inRouteInformationProvider,
    this.inRouteInformationParser,
    this.inRouterDelegate,
    this.inBackButtonDispatcher,
    this.inRoutes,
    this.inInitialRoute,
    this.inOnGenerateRoute,
    this.inOnUnknownRoute,
    this.inNavigatorObservers,
    this.inTransBuilder,
    this.inTitle,
    this.inGenerateTitle,
    this.inTheme,
    this.iniOSTheme,
    this.inDarkTheme,
    this.inThemeMode,
    this.inColor,
    this.inLocale,
    this.inLocalizationsDelegates,
    this.inLocaleListResolutionCallback,
    this.inLocaleResolutionCallback,
    this.inSupportedLocales,
    this.inDebugShowMaterialGrid,
    this.inShowPerformanceOverlay,
    this.inCheckerboardRasterCacheImages,
    this.inCheckerboardOffscreenLayers,
    this.inShowSemanticsDebugger,
    this.inDebugShowCheckedModeBanner,
    this.inShortcuts,
    this.inActions,
    this.inRestorationScopeId,
    this.inScrollBehavior,
    this.inError,
    this.inAsyncError,
  }) : super(
          con: con ?? AppController(),
          controllers: controllers,
          object: object,
          navigatorKey: navigatorKey,
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          backButtonDispatcher: backButtonDispatcher,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: navigatorObservers,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          theme: theme,
          iOSTheme: iOSTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          restorationScopeId: restorationScopeId,
          scrollBehavior: scrollBehavior,
          debugShowWidgetInspector: debugShowWidgetInspector,
          debugPaintSizeEnabled: debugPaintSizeEnabled,
          debugPaintBaselinesEnabled: debugPaintBaselinesEnabled,
          debugPaintPointersEnabled: debugPaintPointersEnabled,
          debugPaintLayerBordersEnabled: debugPaintLayerBordersEnabled,
          debugRepaintRainbowEnabled: debugRepaintRainbowEnabled,
          errorHandler: errorHandler,
          errorScreen: errorScreen,
          errorReport: errorReport,
        ) {
    // In case null was explicitly passed in.
    useMaterial ??= false;
    useCupertino ??= false;
    switchUI ??= false;

    if (UniversalPlatform.isAndroid) {
      if (switchUI!) {
        useMaterial = false;
        useCupertino = true;
      } else if (useCupertino!) {
        useMaterial = false;
      } else {
        useMaterial = true;
        useCupertino = false;
      }
    } else if (UniversalPlatform.isIOS) {
      if (switchUI!) {
        useMaterial = true;
        useCupertino = false;
      } else if (useMaterial!) {
        useCupertino = false;
      } else {
        useMaterial = false;
        useCupertino = true;
      }
    } else {
      useMaterial = true;
      useCupertino = false;
    }

    // These ones can't be changed.
    _isMaterial = useMaterial;
    _isCupertino = useCupertino;
  }

  Key? key;

  final Widget? home;

  // Explicitly use the Material theme
  bool? useMaterial;
  // Explicitly use the Cupertino theme
  bool? useCupertino;
  // Use Cupertino UI in Android and vice versa.
  bool? switchUI;

  // The platform paradigm determined at startup. Can't be changed.
  bool? get isMaterial => _isMaterial;
  bool? _isMaterial;
  bool? get isCupertino => _isCupertino;
  bool? _isCupertino;

  final Widget Function()? inHome;
  final RouteInformationProvider Function()? inRouteInformationProvider;
  final RouteInformationParser<Object> Function()? inRouteInformationParser;
  final RouterDelegate<Object> Function()? inRouterDelegate;
  final BackButtonDispatcher Function()? inBackButtonDispatcher;
  final Map<String, WidgetBuilder> Function()? inRoutes;
  final String Function()? inInitialRoute;
  final RouteFactory Function()? inOnGenerateRoute;
  final RouteFactory Function()? inOnUnknownRoute;
  final List<NavigatorObserver> Function()? inNavigatorObservers;
  final TransitionBuilder Function()? inTransBuilder;
  final String Function()? inTitle;
  final GenerateAppTitle? inGenerateTitle;
  final ThemeData Function()? inTheme;
  final CupertinoThemeData Function()? iniOSTheme;
  final ThemeData Function()? inDarkTheme;
  final ThemeMode Function()? inThemeMode;
  final Color Function()? inColor;
  final Locale Function()? inLocale;
  final Iterable<LocalizationsDelegate<dynamic>> Function()?
      inLocalizationsDelegates;
  final LocaleListResolutionCallback? inLocaleListResolutionCallback;
  final LocaleResolutionCallback? inLocaleResolutionCallback;
  final Iterable<Locale> Function()? inSupportedLocales;
  final bool Function()? inDebugShowMaterialGrid;
  final bool Function()? inShowPerformanceOverlay;
  final bool Function()? inCheckerboardRasterCacheImages;
  final bool Function()? inCheckerboardOffscreenLayers;
  final bool Function()? inShowSemanticsDebugger;
  final bool Function()? inDebugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent> Function()? inShortcuts;
  final Map<Type, Action<Intent>> Function()? inActions;
  final String Function()? inRestorationScopeId;
  final ScrollBehavior Function()? inScrollBehavior;
  final void Function(FlutterErrorDetails details)? inError;
  final bool Function(FlutterErrorDetails details)? inAsyncError;

  // The error flag.
  bool _inError = false;

  /// Supply to the 'home' StatefulWidget
  /// Allows you to 're-create' the home widget's state object.
  static Key homeKey = UniqueKey();

  /// The App State's initialization function.
  @override
  void initState() {
    /// If not already, have the app assign the theme in the Material platform.
    final themeData = theme ?? onTheme();

    if (themeData != null) {
      v.App.themeData = themeData;
    }

    // The app may supply a theme.
    v.App.themeData ??= ThemeData.light();

    /// If not already, have the app assign the theme in the Cupertino platform.
    final iOSThemeData = iOSTheme ?? oniOSTheme();

    if (iOSThemeData != null) {
      v.App.iOSTheme = iOSThemeData;
    }

    v.App.iOSTheme ??=
        MaterialBasedCupertinoThemeData(materialTheme: v.App.themeData!);

    /// Called last. A Controller may want to change the 'theme.'
    super.initState();
  }

  /// Override to impose your own WidgetsApp (like CupertinoApp or MaterialApp)
  @override
  Widget buildApp(BuildContext context) {
    //
    if (useCupertino!) {
      return CupertinoApp(
        key: key ?? v.App.widgetsAppKey,
        navigatorKey: navigatorKey ?? onNavigatorKey(),
        routes: routes ?? onRoutes() ?? const <String, WidgetBuilder>{},
        initialRoute: initialRoute ?? onInitialRoute(),
        onGenerateRoute: onGenerateRoute ?? onOnGenerateRoute(),
        onUnknownRoute: onUnknownRoute ?? onOnUnknownRoute(),
        navigatorObservers: navigatorObservers ??
            onNavigatorObservers() ??
            const <NavigatorObserver>[],
        builder: builder ?? onBuilder(),
        title: title = onTitle(),
        onGenerateTitle: onGenerateTitle ?? onOnGenerateTitle(context),
        color: color ?? onColor() ?? Colors.blue,
        theme: iOSTheme ?? oniOSTheme() ?? v.App.iOSTheme,
        locale: locale ?? onLocale(),
        localizationsDelegates:
            localizationsDelegates ?? onLocalizationsDelegates(),
        localeListResolutionCallback:
            localeListResolutionCallback ?? onLocaleListResolutionCallback(),
        localeResolutionCallback:
            localeResolutionCallback ?? onLocaleResolutionCallback(),
        supportedLocales: supportedLocales ?? onSupportedLocales(),
        showPerformanceOverlay:
            showPerformanceOverlay ?? onShowPerformanceOverlay(),
        checkerboardRasterCacheImages:
            checkerboardRasterCacheImages ?? onCheckerboardRasterCacheImages(),
        checkerboardOffscreenLayers:
            checkerboardOffscreenLayers ?? onCheckerboardOffscreenLayers(),
        showSemanticsDebugger:
            showSemanticsDebugger ?? onShowSemanticsDebugger(),
        debugShowCheckedModeBanner:
            debugShowCheckedModeBanner ?? onDebugShowCheckedModeBanner(),
        shortcuts: shortcuts ?? onShortcuts(),
        actions: actions ?? onActions(),
        restorationScopeId: restorationScopeId ?? onRestorationScopeId(),
        scrollBehavior: scrollBehavior ?? onScrollBehavior(),
        // Let the parameters run before the home parameter.
        home: home ?? onHome(),
      );
    } else {
      _routerDelegate = routerDelegate ?? onRouterDelegate();
      _routeInformationParser =
          routeInformationParser ?? onRouteInformationParser();
      if (_routerDelegate == null || _routeInformationParser == null) {
        return MaterialApp(
          key: key ?? v.App.widgetsAppKey,
          navigatorKey: navigatorKey ?? onNavigatorKey(),
          scaffoldMessengerKey:
              scaffoldMessengerKey ?? onScaffoldMessengerKey(),
          routes: routes ?? onRoutes() ?? const <String, WidgetBuilder>{},
          initialRoute: initialRoute ?? onInitialRoute(),
          onGenerateRoute: onGenerateRoute ?? onOnGenerateRoute(),
          onUnknownRoute: onUnknownRoute ?? onOnUnknownRoute(),
          navigatorObservers: navigatorObservers ??
              onNavigatorObservers() ??
              const <NavigatorObserver>[],
          builder: builder ?? onBuilder(),
          title: title = onTitle(),
          onGenerateTitle: onGenerateTitle ?? onOnGenerateTitle(context),
          color: color ?? onColor() ?? Colors.white,
          theme: theme ?? onTheme() ?? v.App.themeData,
          darkTheme: darkTheme ?? onDarkTheme(),
          themeMode: themeMode ?? onThemeMode(),
          locale: locale ?? onLocale(),
          localizationsDelegates: onLocalizationsDelegates(),
          localeListResolutionCallback:
              localeListResolutionCallback ?? onLocaleListResolutionCallback(),
          localeResolutionCallback:
              localeResolutionCallback ?? onLocaleResolutionCallback(),
          supportedLocales: supportedLocales ?? onSupportedLocales(),
          debugShowMaterialGrid:
              debugShowMaterialGrid ?? onDebugShowMaterialGrid(),
          showPerformanceOverlay:
              showPerformanceOverlay ?? onShowPerformanceOverlay(),
          checkerboardRasterCacheImages: checkerboardRasterCacheImages ??
              onCheckerboardRasterCacheImages(),
          checkerboardOffscreenLayers:
              checkerboardOffscreenLayers ?? onCheckerboardOffscreenLayers(),
          showSemanticsDebugger:
              showSemanticsDebugger ?? onShowSemanticsDebugger(),
          debugShowCheckedModeBanner:
              debugShowCheckedModeBanner ?? onDebugShowCheckedModeBanner(),
          shortcuts: shortcuts ?? onShortcuts(),
          actions: actions ?? onActions(),
          restorationScopeId: restorationScopeId ?? onRestorationScopeId(),
          scrollBehavior: scrollBehavior ?? onScrollBehavior(),
          // Let the parameters run before the home parameter.
          home: home ?? onHome(),
        );
      } else {
        return MaterialApp.router(
          key: key ?? v.App.widgetsAppKey,
          backButtonDispatcher:
              backButtonDispatcher ?? onBackButtonDispatcher(),
          scaffoldMessengerKey:
              scaffoldMessengerKey ?? onScaffoldMessengerKey(),
          builder: builder ?? onBuilder(),
          title: title = onTitle(),
          onGenerateTitle: onGenerateTitle ?? onOnGenerateTitle(context),
          color: color ?? onColor() ?? Colors.white,
          theme: theme ?? onTheme() ?? v.App.themeData,
          darkTheme: darkTheme ?? onDarkTheme(),
          themeMode: themeMode ?? onThemeMode(),
          locale: locale ?? onLocale(),
          localizationsDelegates: onLocalizationsDelegates(),
          localeListResolutionCallback:
              localeListResolutionCallback ?? onLocaleListResolutionCallback(),
          localeResolutionCallback:
              localeResolutionCallback ?? onLocaleResolutionCallback(),
          supportedLocales: supportedLocales ?? onSupportedLocales(),
          debugShowMaterialGrid:
              debugShowMaterialGrid ?? onDebugShowMaterialGrid(),
          showPerformanceOverlay:
              showPerformanceOverlay ?? onShowPerformanceOverlay(),
          checkerboardRasterCacheImages: checkerboardRasterCacheImages ??
              onCheckerboardRasterCacheImages(),
          checkerboardOffscreenLayers:
              checkerboardOffscreenLayers ?? onCheckerboardOffscreenLayers(),
          showSemanticsDebugger:
              showSemanticsDebugger ?? onShowSemanticsDebugger(),
          debugShowCheckedModeBanner:
              debugShowCheckedModeBanner ?? onDebugShowCheckedModeBanner(),
          shortcuts: shortcuts ?? onShortcuts(),
          actions: actions ?? onActions(),
          restorationScopeId: restorationScopeId ?? onRestorationScopeId(),
          scrollBehavior: scrollBehavior ?? onScrollBehavior(),
          routeInformationProvider:
              routeInformationProvider ?? onRouteInformationProvider(),
          routeInformationParser: _routeInformationParser!,
          routerDelegate: _routerDelegate!,
        );
      }
    }
  }

  @override
  void dispose() {
    _navigatorKey = null;
    super.dispose();
  }

  /// Override if you like to customize error handling.
  @override
  void onError(FlutterErrorDetails details) {
    // Don't call this routine within itself.
    if (_inError) {
      return;
    }
    _inError = true;
    // Note, the AppController's Error Handler takes precedence if any.
    if (con != null) {
      con!.onError(details);
    } else if (inError != null) {
      inError!(details);
    } else {
      super.onError(details);
    }
    _inError = false;
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  @override
  void reassemble() {
    v.App.hotReload = true;
    super.reassemble();
  }

  /// Explicity change to a particular interface.
  void changeUI(String? ui) {
    if (ui == null || ui.isEmpty) {
      return;
    }
    // Assigned to the 'home' StatefulWidget to re-create Stat object.
    homeKey = UniqueKey();
    ui = ui.trim();
    if (ui != 'Material' && ui != 'Cupertino') {
      return;
    }
    if (ui == 'Material') {
      useMaterial = true;
      useCupertino = false;
      switchUI = !UniversalPlatform.isAndroid;
    } else {
      useMaterial = false;
      useCupertino = true;
      switchUI = UniversalPlatform.isAndroid;
    }
  }

  GlobalKey<NavigatorState> onNavigatorKey() =>
      _navigatorKey ??= GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState>? _navigatorKey;

  RouteInformationProvider? onRouteInformationProvider() =>
      inRouteInformationProvider != null ? inRouteInformationProvider!() : null;

  RouteInformationParser<Object>? onRouteInformationParser() =>
      inRouteInformationParser != null ? inRouteInformationParser!() : null;

  RouteInformationParser<Object>? _routeInformationParser;

  RouterDelegate<Object>? onRouterDelegate() =>
      inRouterDelegate != null ? inRouterDelegate!() : null;

  RouterDelegate<Object>? _routerDelegate;

  BackButtonDispatcher? onBackButtonDispatcher() =>
      inBackButtonDispatcher != null ? inBackButtonDispatcher!() : null;

  GlobalKey<ScaffoldMessengerState> onScaffoldMessengerKey() =>
      _scaffoldMessengerKey ??= GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  Widget? onHome() => inHome != null ? inHome!() : null;

  Map<String, WidgetBuilder>? onRoutes() =>
      inRoutes != null ? inRoutes!() : const <String, WidgetBuilder>{};

  String? onInitialRoute() => inInitialRoute != null ? inInitialRoute!() : null;

  RouteFactory? onOnGenerateRoute() =>
      inOnGenerateRoute != null ? inOnGenerateRoute!() : null;

  RouteFactory? onOnUnknownRoute() =>
      inOnUnknownRoute != null ? inOnUnknownRoute!() : null;

  List<NavigatorObserver>? onNavigatorObservers() =>
      inNavigatorObservers != null
          ? inNavigatorObservers!()
          : const <NavigatorObserver>[];

  TransitionBuilder? onBuilder() =>
      inTransBuilder != null ? inTransBuilder!() : null;

  String onTitle() => inTitle != null ? inTitle!() : title ?? '';

  GenerateAppTitle? onOnGenerateTitle(BuildContext context) => inGenerateTitle;

  Color? onColor() => inColor != null ? inColor!() : null;

  ThemeData? onTheme() => inTheme != null ? inTheme!() : null;

  CupertinoThemeData? oniOSTheme() => iniOSTheme != null ? iniOSTheme!() : null;

  ThemeData? onDarkTheme() => inDarkTheme != null ? inDarkTheme!() : null;

  ThemeMode onThemeMode() =>
      inThemeMode != null ? inThemeMode!() : ThemeMode.system;

  Locale? onLocale() => inLocale != null ? inLocale!() : null;

  @mustCallSuper
  Iterable<LocalizationsDelegate<dynamic>> onLocalizationsDelegates() sync* {
    if (localizationsDelegates != null) {
      yield* localizationsDelegates!;
    }
    if (inLocalizationsDelegates != null) {
      yield* inLocalizationsDelegates!();
    }
    // Supply MaterialLocalizations just in case you're in Cupertino interface.
    yield DefaultMaterialLocalizations.delegate;
    // Very important to allow Material to Cupertino and back!
    yield v.I10nDelegate();
  }

  LocaleListResolutionCallback? onLocaleListResolutionCallback() =>
      inLocaleListResolutionCallback;

  /// Turn to the I10n class to provide the locale.
  LocaleResolutionCallback? onLocaleResolutionCallback() =>
      inLocaleResolutionCallback ?? v.I10n.localeResolutionCallback;

  Iterable<Locale> onSupportedLocales() => inSupportedLocales != null
      ? inSupportedLocales!()
      : const <Locale>[Locale('en', 'US')];

  bool onDebugShowMaterialGrid() =>
      // ignore: avoid_bool_literals_in_conditional_expressions
      inDebugShowMaterialGrid != null ? inDebugShowMaterialGrid!() : false;

  bool onShowPerformanceOverlay() =>
      // ignore: avoid_bool_literals_in_conditional_expressions
      inShowPerformanceOverlay != null ? inShowPerformanceOverlay!() : false;

  bool onCheckerboardRasterCacheImages() =>
      // ignore: avoid_bool_literals_in_conditional_expressions
      inCheckerboardRasterCacheImages != null
          ? inCheckerboardRasterCacheImages!()
          : false;

  // ignore: avoid_bool_literals_in_conditional_expressions
  bool onCheckerboardOffscreenLayers() => inCheckerboardOffscreenLayers != null
      ? inCheckerboardOffscreenLayers!()
      : false;

  bool onShowSemanticsDebugger() =>
      // ignore: avoid_bool_literals_in_conditional_expressions
      inShowSemanticsDebugger != null ? inShowSemanticsDebugger!() : false;

  // ignore: avoid_bool_literals_in_conditional_expressions
  bool onDebugShowCheckedModeBanner() => inDebugShowCheckedModeBanner != null
      ? inDebugShowCheckedModeBanner!()
      : true;

  Map<LogicalKeySet, Intent>? onShortcuts() =>
      inShortcuts != null ? inShortcuts!() : null;

  Map<Type, Action<Intent>>? onActions() =>
      inActions != null ? inActions!() : null;

  String? onRestorationScopeId() =>
      inRestorationScopeId != null ? inRestorationScopeId!() : null;

  ScrollBehavior? onScrollBehavior() =>
      inScrollBehavior != null ? inScrollBehavior!() : null;
}

/// The underlying State object representing the App's View in the MVC pattern.
/// Allows for setting debug settings and defining the App's error routine.
abstract class _AppState<T extends mvc.AppStatefulWidgetMVC>
    extends mvc.AppStateMVC<T> {
  //
  _AppState({
    this.con,
    List<ControllerMVC>? controllers,
    Object? object,
    this.navigatorKey,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.scaffoldMessengerKey,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.iOSTheme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales,
    this.debugShowMaterialGrid,
    this.showPerformanceOverlay,
    this.checkerboardRasterCacheImages,
    this.checkerboardOffscreenLayers,
    this.showSemanticsDebugger,
    this.debugShowWidgetInspector,
    this.debugShowCheckedModeBanner,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.debugPaintSizeEnabled,
    this.debugPaintBaselinesEnabled,
    this.debugPaintPointersEnabled,
    this.debugPaintLayerBordersEnabled,
    this.debugRepaintRainbowEnabled,
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
  }) : super(
          controller: con,
          controllers: controllers,
          object: object,
        ) {
    // Listen to the device's connectivity.
    v.App.addConnectivityListener(con);
    // In case null was explicitly passed in.
    routes ??= const <String, WidgetBuilder>{};
    navigatorObservers ??= const <NavigatorObserver>[];
//    title ??= '';
//    color ??= Colors.blue;
    debugShowMaterialGrid ??= false;
    showPerformanceOverlay ??= false;
    checkerboardRasterCacheImages ??= false;
    checkerboardOffscreenLayers ??= false;
    showSemanticsDebugger ??= false;
    debugShowWidgetInspector ??= false;
    debugShowCheckedModeBanner ??= true;
    debugPaintSizeEnabled ??= false;
    debugPaintBaselinesEnabled ??= false;
    debugPaintPointersEnabled ??= false;
    debugPaintLayerBordersEnabled ??= false;
    debugRepaintRainbowEnabled ??= false;

    assert(() {
      /// Highlights UI while debugging.
      debug.debugPaintSizeEnabled = debugPaintSizeEnabled ?? false;
      debug.debugPaintBaselinesEnabled = debugPaintBaselinesEnabled ?? false;
      debug.debugPaintPointersEnabled = debugPaintPointersEnabled ?? false;
      debug.debugPaintLayerBordersEnabled =
          debugPaintLayerBordersEnabled ?? false;
      debug.debugRepaintRainbowEnabled = debugRepaintRainbowEnabled ?? false;
      debug.debugRepaintTextRainbowEnabled =
          debugRepaintRainbowEnabled ?? false;
      return true;
    }());

    if (errorHandler != null || errorScreen != null || errorReport != null) {
      // Supply a customized error handling.
      _errorHandler = v.AppErrorHandler(
          handler: errorHandler, builder: errorScreen, report: errorReport);
    }
  }
  final AppController? con;
  v.AppErrorHandler? _errorHandler;

  /// All the fields found in the widgets, MaterialApp and CupertinoApp
  GlobalKey<NavigatorState>? navigatorKey;
  RouteInformationProvider? routeInformationProvider;
  RouteInformationParser<Object>? routeInformationParser;
  RouterDelegate<Object>? routerDelegate;
  BackButtonDispatcher? backButtonDispatcher;
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  Map<String, WidgetBuilder>? routes;
  String? initialRoute;
  RouteFactory? onGenerateRoute;
  RouteFactory? onUnknownRoute;
  List<NavigatorObserver>? navigatorObservers;
  TransitionBuilder? builder;
  String? title;
  GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme;
  final CupertinoThemeData? iOSTheme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;
  Color? color;
  Locale? locale;
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  LocaleListResolutionCallback? localeListResolutionCallback;
  LocaleResolutionCallback? localeResolutionCallback;
  Iterable<Locale>? supportedLocales;
  bool? debugShowMaterialGrid;
  bool? showPerformanceOverlay;
  bool? checkerboardRasterCacheImages;
  bool? checkerboardOffscreenLayers;
  bool? showSemanticsDebugger;
  bool? debugShowWidgetInspector;
  bool? debugShowCheckedModeBanner;
  Map<LogicalKeySet, Intent>? shortcuts;
  Map<Type, Action<Intent>>? actions;
  String? restorationScopeId;
  ScrollBehavior? scrollBehavior;

  /// Highlights UI while debugging.
  bool? debugPaintSizeEnabled;
  bool? debugPaintBaselinesEnabled;
  bool? debugPaintPointersEnabled;
  bool? debugPaintLayerBordersEnabled;
  bool? debugRepaintRainbowEnabled;

  @override
  void dispose() {
    _errorHandler?.dispose();
    super.dispose();
  }

  /// Supply the function as a instance member and not a static member in this framework
  /// In such a framework touched by many hands, it's best to keep this function confinded.
  void inheritWidget(BuildContext context) =>
      mvc.AppStateMVC.inheritWidget(context);
}

/// The Error Screen if something happens at start up.
class AppError extends AppState {
  //
  AppError(Object exception, {Key? key})
      : super(home: _AppError(exception, key: key));
}

class _AppError extends StatefulWidget {
  //
  const _AppError(this.exception, {Key? key}) : super(key: key);
  final Object exception;
  @override
  State<StatefulWidget> createState() => _AppErrorState();
}

class _AppErrorState extends State<_AppError> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(widget.exception.toString()),
        ),
      );
}
