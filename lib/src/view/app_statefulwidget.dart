///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  24 Dec 2018
///

import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart' show FlutterExceptionHandler, Key;

import 'package:flutter/material.dart';

import 'package:mvc_application/controller.dart' show Assets, ControllerMVC;

import 'package:mvc_application/view.dart' as v
    show App, AppState, AppStatefulWidgetMVC, ReportErrorHandler, SetState;

/// Export the classes needed to use this file.
export 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;

import 'package:prefs/prefs.dart' show Prefs;

import 'package:universal_platform/universal_platform.dart';

/// Error Screen Builder if an error occurs.
typedef ErrorWidgetBuilder = Widget Function(
    FlutterErrorDetails flutterErrorDetails);

/// The widget passed to runApp().
@Deprecated("Use AppStatefulWidget instead. It's a StatefulWidget after all!")
abstract class AppMVC extends AppStatefulWidget {
  /// The entrypoint of the framework passed to runApp()
  /// This is a StatelessWidget where you can define
  /// the loading screen or the App's error handling.
  AppMVC({
    Key? key,
    Widget? loadingScreen,
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
    bool allowNewHandlers = true,
  }) : super(
          key: key,
          loadingScreen: loadingScreen,
          errorHandler: errorHandler,
          errorScreen: errorScreen,
          errorReport: errorReport,
          allowNewHandlers: allowNewHandlers,
        );
}

/// The widget passed to runApp().
/// The 'App' Stateful Widget. It's the StatefulWidget for the 'App' State object.
/// extends the AppStatefulWidgetMVC found in the package, mvc_pattern.
abstract class AppStatefulWidget extends StatefulWidget {
  /// The entrypoint of the framework passed to runApp()
  /// This is a StatelessWidget where you can define
  /// the loading screen or the App's error handling.
  AppStatefulWidget({
    Key? key,
    this.loadingScreen,
    FlutterExceptionHandler? errorHandler,
    ErrorWidgetBuilder? errorScreen,
    v.ReportErrorHandler? errorReport,
    bool allowNewHandlers = true,
  })  : _app = v.App(
          errorHandler: errorHandler,
          errorScreen: errorScreen,
          errorReport: errorReport,
          allowNewHandlers: allowNewHandlers,
        ),
        super(key: key ?? GlobalKey());

  /// A simple screen displayed then starting up.
  final Widget? loadingScreen;

  // /// Reference to the 'app' object.
  // v.App? get app => _app;
  final v.App _app;

  /// Create the app-level State object.
  v.AppState createAppState();

  /// Creates the App's State object.
  @override
  State createState() => _AppState();
}

class _AppState extends State<AppStatefulWidget> {
  //
  //
  v.AppState? _appState;

  @override
  void initState() {
    super.initState();
    appKey = GlobalKey();
  }

  late GlobalKey appKey;

  /// Implement from the abstract v.AppStatefulWidgetMVC to create the View!
  @override
  Widget build(BuildContext context) {
    Assets.init(context);
    return FutureBuilder<bool>(
        key: UniqueKey(), // UniqueKey() for hot reload
        future: initAsync(),
        initialData: false,
        builder: (_, snapshot) =>
            _futureBuilder(snapshot, widget.loadingScreen));
  }

  /// Runs all the asynchronous operations necessary before the app can proceed.
  Future<bool> initAsync() async {
    //
    var init = _appState != null;

    // Possibly this app's called by another app.
    if (init && !v.App.hotReload) {
      return init;
    }
    // or it's a hot reload

    init = true;

    final _widget = widget;

    try {
      /// Initialize System Preferences
      await Prefs.init();

      /// Collect installation & connectivity information
      await _widget._app.initInternal();

      /// Set theme using App's menu system if any theme was saved.
      v.App.setThemeData();

      // Create 'the View' for this MVC app.
      _appState = _widget.createAppState();

      // Supply the state object to the App object.
      _widget._app.setAppState(_appState);

      // Collect the device's information but not in certain platforms
      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        await v.App.getDeviceInfo();
      }

      // Perform any asynchronous operations.
      await _appState!.initAsync();
      //
    } catch (e) {
      init = false;
      v.App.isInit = false;
      rethrow;
    }
    return v.App.isInit = init;
  }

  /// Clean up resources before the app is finally terminated.
  @override
  @mustCallSuper
  void dispose() {
    // Determine if this app has been called by another app.
    final state = context.findRootAncestorStateOfType<_AppState>();
    // Don't dispose if this app is called by another app
    if (state == this) {
      Prefs.dispose();
      // Assets.init(context); called in App.build() -gp
      Assets.dispose();
      //
      widget._app.dispose();
    }
    // Remove the reference to the app's view
    _appState = null;
    //
    super.dispose();
  }

  /// Run the CircularProgressIndicator() until asynchronous operations are
  /// completed before the app proceeds.
  Widget _futureBuilder(AsyncSnapshot<bool> snapshot, Widget? loading) {
    //
    if (snapshot.hasData &&
        snapshot.data! &&
        (v.App.isInit != null && v.App.isInit!)) {
      // Supply a GlobalKey so the 'App' State object is not disposed of if moved in Widget tree.
      return _AppStatefulWidget(key: appKey, appState: _appState!);
      //
    } else if (snapshot.hasError) {
      //
      final dynamic exception = snapshot.error;

      final details = FlutterErrorDetails(
        exception: exception,
        stack: exception is Error ? exception.stackTrace : null,
        library: 'app_statefulwidget.dart',
        context: ErrorDescription('While getting ready in FutureBuilder Async'),
      );

      var handled = false;

      if (_appState != null) {
        //
        handled = _appState!.onAsyncError(details);
      }

      if (!handled) {
        //
        widget._app.onAsyncError(snapshot);
      }
      return v.App.errorHandler!.displayError(details);
      //
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData &&
        !snapshot.data!) {
      //
      final FlutterErrorDetails details = FlutterErrorDetails(
        exception: Exception('App failed to initialize'),
        library: 'app_statefulwidget.dart',
        context: ErrorDescription('Please, notify admin.'),
      );

      FlutterError.reportError(details);

      return ErrorWidget.builder(details);
    } else {
      //
      Widget widget;

      if (loading != null) {
        //
        widget = loading;
      } else {
        //
        if (UniversalPlatform.isAndroid || UniversalPlatform.isWeb) {
          //
          widget = const Center(child: CircularProgressIndicator());
        } else {
          //
          widget = const Center(child: CupertinoActivityIndicator());
        }
      }
      return widget;
    }
  }
}

/// The 'App' Stateful Widget. It's the StatefulWidget for the 'App' State object.
/// extends the AppStatefulWidgetMVC found in the package, mvc_pattern.
class _AppStatefulWidget extends v.AppStatefulWidgetMVC {
  /// Requires its 'App' State object be passed as a parameter.
  const _AppStatefulWidget({
    Key? key,
    required this.appState,
  }) : super(key: key);

  /// The framework's 'App' State object.
  final v.AppState appState;

  /// Programmatically creates the App's State object.
  @override
  //ignore: no_logic_in_create_state
  v.AppState createState() => appState;
}

/// Obtains [Controllers<T>] from its ancestors and passes its value to [builder].
///
class ConConsumer<T extends ControllerMVC> extends StatelessWidget {
  /// Requires a builder object and optionally a child Widget.
  /// The builder takes in a particular State Controller.
  const ConConsumer({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// The builder
  final Widget Function(BuildContext context, T? controller, Widget? child)
      builder;

  /// The child widget to pass to [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) => v.SetState(
      builder: (context, [object]) => builder(
            context,
            v.App.vw!.controllerByType<T>(),
            child,
          ));
}
