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
import 'dart:async' show Future;

import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart'
    show FlutterExceptionHandler, Key, mustCallSuper, protected;

import 'package:flutter/material.dart';

import 'package:mvc_application/controller.dart'
    show Assets, AppController, ControllerMVC;

import 'package:mvc_application/view.dart' as v
    show App, AppStatefulWidgetMVC, AppState, ReportErrorHandler, SetState;

import 'package:prefs/prefs.dart' show Prefs;

/// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

/// Export the classes needed to use this file.
export 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;

/// Error Screen Builder if an error occurs.
typedef ErrorWidgetBuilder = Widget Function(
    FlutterErrorDetails flutterErrorDetails);

/// The widget passed to runApp().
abstract class AppMVC extends StatelessWidget {
  /// The entrypoint of the framework passed to runApp()
  /// This is a StatelessWidget where you can define
  /// the loading screen or the App's error handling.
  AppMVC({
    this.controller,
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
        super(key: key) {
    // Listen to the device's connectivity.
    v.App.addConnectivityListener(controller);
  }
  final v.App _app;

  /// The 'App' Controller passed in to have its initAsync() function called.
  final AppController? controller;

  /// Create the app-level State object of type, AppState.
  @protected
  v.AppState createState();

  /// Gives access to the App's View.
  static v.AppState? get vw => _vw;
  static v.AppState? _vw;

  /// Supply a loading screen.
  final Widget? loadingScreen;

  /// Implement from the abstract v.AppStatefulWidgetMVC to create the View!
  @override
  Widget build(BuildContext context) {
    Assets.init(context);
    return FutureBuilder<bool>(
        key: UniqueKey(), // UniqueKey() for hot reload
        future: initAsync(),
        initialData: false,
        builder: (_, snapshot) => _futureBuilder(snapshot, loadingScreen));
  }

  /// Runs all the asynchronous operations necessary before the app can proceed.
  Future<bool> initAsync() async {
    //
    var init = v.App.isInit;

    // This has already been called??
    // Possibly this app's called by another app.
    if (init != null) {
      return init;
    }

    init = true;

    try {
      //
      if (!v.App.hotReload) {
        /// Initialize System Preferences
        await Prefs.init();

        /// Collect installation & connectivity information
        await _app.initInternal();

        /// Set theme using App's menu system if any theme was saved.
        v.App.setThemeData();

        // Calls AppController passed in through the runApp() function
        if (controller != null) {
          init = await controller!.initAsync();
        }
      }

      if (init) {
        // Create 'the View' for this MVC app.
        _vw = createState();

        // Supply the state object to the App object.
        init = _app.setAppState(_vw);

        if (init) {
          init = await _vw!.initAsync();
        }

        // Now add the AppController passed in through the runApp() function
        _vw!.add(controller);

        // Collect the device's information but not in certain platforms
        if (!UniversalPlatform.isWindows && !UniversalPlatform.isWeb) {
          await v.App.getDeviceInfo();
        }
      }
    } catch (e) {
      init = false;
      v.App.isInit = false;
      rethrow;
    }
    return v.App.isInit = init;
  }

  /// Clean up resources before the app is finally terminated.
  @mustCallSuper
  void dispose() {
    //
    Prefs.dispose();
    // Assets.init(context); called in App.build() -gp
    Assets.dispose();
    //
    _app.dispose();
    // Remove the reference to the app's view
    _vw = null;
  }

  /// Run the CircularProgressIndicator() until asynchronous operations are
  /// completed before the app proceeds.
  Widget _futureBuilder(AsyncSnapshot<bool> snapshot, Widget? loading) {
    //
    if (snapshot.hasData &&
        snapshot.data! &&
        (v.App.isInit != null && v.App.isInit!)) {
      //
      return AppStatefulWidget(appState: _vw!);
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

      if (_vw != null) {
        //
        handled = _vw!.onAsyncError(details);
      }

      if (!handled) {
        //
        _app.onAsyncError(snapshot);
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

      // } else if (snapshot.connectionState == ConnectionState.done ||
      //     (v.App.isInit != null && v.App.isInit!)) {
      //   return const v.AppStateWidget();
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
class AppStatefulWidget extends v.AppStatefulWidgetMVC {
  /// Requires its 'App' State object be passed as a parameter.
  const AppStatefulWidget({
    Key? key,
    required this.appState,
    @Deprecated("No longer pass 'con' to AppStatefulWidget. Supply to AppState instead.")
        AppController? con,
  }) : super(key: key);

  /// The framework's 'App' State object.
  final v.AppState appState;

  // /// Display the 'app State object' the developer has defined.
  // Widget build(BuildContext context) => appState.build(context);

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
            AppMVC._vw?.controllerByType<T>(),
            child,
          ));
}
