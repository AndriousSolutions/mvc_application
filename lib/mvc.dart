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
///          Created  31 Dec 2018
///
///

export "package:mvc_application/app.dart";
export 'package:mvc_application/model.dart';
export 'package:mvc_application/controller.dart';
export 'package:mvc_application/view.dart' hide ErrorHandler;

import 'package:flutter/material.dart'
    show
        BuildContext,
        Key,
        State,
        StatefulWidget,
        StatelessWidget,
        Widget,
        Center,
        Color,
        GenerateAppTitle,
        GlobalKey,
        Locale,
        LocaleResolutionCallback,
        LocalizationsDelegate,
        NavigatorObserver,
        NavigatorState,
        RouteFactory,
        Scaffold,
        Text,
        ThemeData,
        TransitionBuilder,
        WidgetBuilder;

import 'app.dart' show App;

import 'view.dart' show AppView;

import 'controller.dart' show AppConMVC, AppController;

typedef CreateView = AppView Function();
CreateView _createVW;

/// Passed to runApp() but calls App()
/// No longer effective alternative.
@deprecated
class MVC extends StatelessWidget {
  MVC(
    CreateView createVW, {
    this.key,
    this.con,
    this.loadingScreen,
  }) : super() {
    _createVW = createVW;
  }
  final Key key;
  final AppConMVC con;
  final Widget loadingScreen;

  Widget build(BuildContext context) => _MyApp(
        key: key,
        con: con,
        loadingScreen: loadingScreen,
      );
}

class _MyApp extends App {
  _MyApp({Key key, AppConMVC con, Widget loadingScreen})
      : super(key: key, con: con, loadingScreen: loadingScreen);

  @override
  AppView createView() => _createVW();
}

/// The Model for a simple app.
class ModelMVC {
  ModelMVC() {
    if (_firstMod == null) _firstMod = this;
  }
  static ModelMVC _firstMod;

  /// Allow for easy access to 'the first Model' throughout the application.
  static ModelMVC get mod => _firstMod ?? ModelMVC();
}

class AppError extends ViewMVC {
  AppError(Object exception, {Key key})
      : super(home: _AppError(exception, key: key));
}

class _AppError extends StatefulWidget {
  _AppError(this.exception, {Key key}) : super(key: key);
  final Object exception;
  @override
  State<StatefulWidget> createState() => _AppErrorState();
}

class _AppErrorState extends State<_AppError> {
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text("${widget.exception.toString()}"),
        ),
      );
}

/// Passed as 'View' to MVC class for a simple app.
class ViewMVC extends AppView {
  ViewMVC({
    Widget home,
    AppController con,
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
    Color color,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales,
    bool debugShowMaterialGrid,
    bool showPerformanceOverlay,
    bool checkerboardRasterCacheImages,
    bool checkerboardOffscreenLayers,
    bool showSemanticsDebugger,
    bool debugShowCheckedModeBanner,
  }) : super(
          home: home,
          con: con ?? AppController(),
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
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        );
}
