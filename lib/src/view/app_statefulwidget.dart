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
    show
        App,
        AppStatefulWidgetMVC,
        AppState,
        I10n,
        ReportErrorHandler,
        SetState;

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
  AppMVC({
    this.con,
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
    v.App.addConnectivityListener(con);
  }
  final v.App _app;
  final AppController? con;

  // Create the app-level State object
  @protected
  v.AppState createState();

  /// Gives access to the App's View.
  static v.AppState? get vw => _vw;
  static v.AppState? _vw;

  /// Supply on onboarding screen.
  final Widget? loadingScreen;

  /// Implement from the abstract v.AppStatefulWidgetMVC to create the View!
  @override
  Widget build(BuildContext context) {
    Assets.init(context);
    return FutureBuilder<bool>(
        future: initAsync(),
        initialData: false,
        builder: (_, snapshot) => _asyncBuilder(snapshot, loadingScreen));
  }

  /// Runs all the asynchronous operations necessary before the app can proceed.
  Future<bool> initAsync() async {
    var init = true;
    try {
      if (v.App.hotReload) {
        _vw = createState();
        //todo: No need. Replaced with the initState() function.
        _vw?.con?.initApp();
      } else {
        // Initialize System Preferences
        await Prefs.init();

        // Collect installation & connectivity information
        await _app.initInternal();

        // Collect the device's information
        await v.App.getDeviceInfo();

        // Initiate multi-language translations.
        await v.I10n.initAsync();

        // Set theme using App's menu system if any theme was saved.
        v.App.setThemeData();

        // Calls AppController passed in through the runApp() function
        if (con != null) {
          init = await con!.initAsync();
        }

        if (init) {
          // Create 'the View' for this MVC app.
          _vw = createState();

          // Supply the state object to the App object.
          init = _app.setAppState(_vw);

          if (init) {
            init = await _vw!.initAsync();
          }

          //todo: No need. Replaced with the controller's initState() function.
          if (init) {
            _vw?.con?.initApp();
          }
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
  Widget _asyncBuilder(AsyncSnapshot<bool> snapshot, Widget? loading) {
    if (snapshot.hasData &&
        snapshot.data! &&
        (v.App.isInit != null && v.App.isInit!)) {
      //
      final appWidget = AppStatefulWidget(appState: _vw!, con: con);
      _app.setAppStatefulWidget(appWidget);
      return appWidget;
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

class AppStatefulWidget extends v.AppStatefulWidgetMVC {
  const AppStatefulWidget({
    Key? key,
    required this.appState,
    AppController? con,
  }) : super(key: key, con: con);

  final v.AppState appState;

  /// Display the 'app State object' the developer has defined.
  Widget build(BuildContext context) => appState.build(context);

  /// Programmatically creates the App's State object.
  @override
  //ignore: no_logic_in_create_state
  v.AppState createState() => appState;
}

/// Obtains [Controllers<T>] from its ancestors and passes its value to [builder].
///
class ConConsumer<T extends ControllerMVC> extends StatelessWidget {
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
