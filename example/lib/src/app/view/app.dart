import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/view.dart';

/// App
class TemplateApp extends AppMVC {
  TemplateApp({Key? key}) : super(key: key);
  // This is the 'View' of the application.
  @override
  AppState createState() => TemplateView();
}

/// This is the 'View' of the application. The 'look and feel' of the app.
/// The many null arguments assigned to the many parameters merely are there
/// so you appreciate the many many options you have is setting up your app.
/// Many are not new to Flutter but are a collection of parameters available
/// through the current Flutter framework. Of course, they're optional.
class TemplateView extends AppState {
  TemplateView()
      : super(
          con: TemplateController(),
          controllers: [ContactsController()],
          object: null,
          navigatorKey: null,
          routeInformationProvider: null,
          routeInformationParser: null,
          routerDelegate: null,
          backButtonDispatcher: null,
          scaffoldMessengerKey: null,
          routes: null,
          initialRoute: null,
          onGenerateRoute: null,
          onUnknownRoute: null,
          navigatorObservers: null,
          builder: null,
          title: null,
          onGenerateTitle: null,
          theme: null,
          iOSTheme: null,
          darkTheme: null,
          themeMode: null,
          color: null,
          locale: null,
          localizationsDelegates: [
            I10nDelegate(),
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          localeListResolutionCallback: null,
          localeResolutionCallback: null,
          supportedLocales: I10n.supportedLocales,
          useMaterial: null,
          useCupertino: null,
          switchUI: null,
          debugShowMaterialGrid: null,
          showPerformanceOverlay: null,
          checkerboardRasterCacheImages: null,
          checkerboardOffscreenLayers: null,
          showSemanticsDebugger: null,
          debugShowCheckedModeBanner: false,
          shortcuts: null,
          actions: null,
          restorationScopeId: null,
          scrollBehavior: null,
          debugShowWidgetInspector: null,
          debugPaintSizeEnabled: null,
          debugPaintBaselinesEnabled: null,
          debugPaintPointersEnabled: null,
          debugPaintLayerBordersEnabled: null,
          debugRepaintRainbowEnabled: null,
          errorHandler: null,
          errorScreen: null,
          errorReport: null,
          // The following 'in' parameters provide you a means to place inline functions.
          // Allow you to provide values to the parameters above that require more elaborate computations.
          inHome: null,
          inRouteInformationProvider: null,
          inRouteInformationParser: null,
          inRouterDelegate: null,
          inBackButtonDispatcher: null,
          inRoutes: null,
          inInitialRoute: null,
          inOnGenerateRoute: null,
          inOnUnknownRoute: null,
          inNavigatorObservers: null,
          inTransBuilder: null,
          inTitle: () => I10n.s('Demo App'),
          inGenerateTitle: null,
          inTheme: null,
          iniOSTheme: null,
          inDarkTheme: null,
          inThemeMode: null,
          inColor: null,
          inLocale: null,
          inLocalizationsDelegates: null,
          inLocaleListResolutionCallback: null,
          inLocaleResolutionCallback: null,
          inSupportedLocales: null,
          inDebugShowMaterialGrid: null,
          inShowPerformanceOverlay: null,
          inCheckerboardRasterCacheImages: null,
          inCheckerboardOffscreenLayers: null,
          inShowSemanticsDebugger: null,
          inDebugShowCheckedModeBanner: null,
          inShortcuts: null,
          inActions: null,
          inRestorationScopeId: null,
          inScrollBehavior: null,
          inError: null,
          inAsyncError: null,
        );

  /// The following 'on' parameters allow you to provide values to the parameters
  /// above with even more elaborate computations overwriting all other means above.
  @override
  GlobalKey<NavigatorState> onNavigatorKey() => super.onNavigatorKey();

  @override
  RouteInformationProvider? onRouteInformationProvider() =>
      super.onRouteInformationProvider();

  @override
  RouteInformationParser<Object>? onRouteInformationParser() =>
      super.onRouteInformationParser();

  @override
  RouterDelegate<Object>? onRouterDelegate() => super.onRouterDelegate();

  @override
  BackButtonDispatcher? onBackButtonDispatcher() =>
      super.onBackButtonDispatcher();

  @override
  GlobalKey<ScaffoldMessengerState> onScaffoldMessengerKey() =>
      super.onScaffoldMessengerKey();

  /// The commented line below displays what has been overwritten.
  @override
  Widget onHome() => (con as TemplateController).onHome();
//  Widget? onHome() => inHome != null ? inHome!() : null;

  @override
  Map<String, WidgetBuilder>? onRoutes() => super.onRoutes();

  @override
  String? onInitialRoute() => super.onInitialRoute();

  @override
  RouteFactory? onOnGenerateRoute() => super.onOnGenerateRoute();

  @override
  RouteFactory? onOnUnknownRoute() => super.onOnUnknownRoute();

  @override
  List<NavigatorObserver>? onNavigatorObservers() =>
      super.onNavigatorObservers();

  @override
  TransitionBuilder? onBuilder() => super.onBuilder();

  /// Note, the 'onTitle()' would overwrite the inTitle() defined above.
  @override
  String onTitle() => inTitle != null ? inTitle!() : title ?? '';

  @override
  GenerateAppTitle? onOnGenerateTitle(BuildContext context) =>
      super.onOnGenerateTitle(context);

  @override
  Color? onColor() => super.onColor();

  @override
  ThemeData? onTheme() => super.onTheme();

  @override
  CupertinoThemeData? oniOSTheme() => super.oniOSTheme();

  @override
  ThemeData? onDarkTheme() => super.onDarkTheme();

  @override
  ThemeMode onThemeMode() => super.onThemeMode();

  @override
  Locale? onLocale() => super.onLocale();

  @override
  Iterable<LocalizationsDelegate<dynamic>> onLocalizationsDelegates() =>
      super.onLocalizationsDelegates();

  @override
  LocaleListResolutionCallback? onLocaleListResolutionCallback() =>
      super.onLocaleListResolutionCallback();

  @override
  LocaleResolutionCallback? onLocaleResolutionCallback() =>
      super.onLocaleResolutionCallback();

  @override
  Iterable<Locale> onSupportedLocales() => super.onSupportedLocales();

  @override
  bool onDebugShowMaterialGrid() => super.onDebugShowMaterialGrid();

  @override
  bool onShowPerformanceOverlay() => super.onShowPerformanceOverlay();

  @override
  bool onCheckerboardRasterCacheImages() =>
      super.onCheckerboardRasterCacheImages();

  @override
  bool onCheckerboardOffscreenLayers() => super.onCheckerboardOffscreenLayers();

  @override
  bool onShowSemanticsDebugger() => super.onShowSemanticsDebugger();

  @override
  bool onDebugShowCheckedModeBanner() => super.onDebugShowCheckedModeBanner();

  @override
  Map<LogicalKeySet, Intent>? onShortcuts() => super.onShortcuts();

  @override
  Map<Type, Action<Intent>>? onActions() => super.onActions();

  @override
  String? onRestorationScopeId() => super.onRestorationScopeId();

  @override
  ScrollBehavior? onScrollBehavior() => super.onScrollBehavior();
}
