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

//import 'dart:io' show Platform;

import 'dart:async' show Future;

// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

import 'package:flutter/foundation.dart'
    show FlutterExceptionHandler, Key, kIsWeb, mustCallSuper, protected;

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:mvc_application/controller.dart' show AppConMVC, ControllerMVC;

import 'package:mvc_application/view.dart' as v
    show
        App,
        AppMVC,
        AppState,
        AppStateWidget,
        I10n,
        ReportErrorHandler,
        SetState;

import 'package:mvc_application/controller.dart' show Assets;

import 'package:prefs/prefs.dart' show Prefs;

// Export the classes needed to use this file.
export 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;

/// Error Screen Builder if an error occurs.
typedef ErrorWidgetBuilder = Widget Function(
    FlutterErrorDetails flutterErrorDetails);

/// The app-level StatefulWidget
/// The widget passed to runApp().
abstract class AppStatefulWidget extends v.AppMVC {
  // You must supply a 'View.'
  AppStatefulWidget({
    AppConMVC? con,
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
        super(con: con, key: key) {
    // Listen to the device's connectivity.
    _app.addConnectivityListener(con);
    _app.setAppStatefulWidget(this);
  }
  final v.App _app;

  @protected
  v.AppState createView();

  /// Gives access to the App's View. The 'MyView' you first work with.
  static v.AppState? get vw => _vw;
  static v.AppState? _vw;

  // /// The context used by the App's view.
  // static BuildContext get context => _context;
  // static BuildContext _context;

  /// The snapshot used by the App's View.
  @Deprecated('getter, snapshot, will be removed.')
  static AsyncSnapshot<bool>? get snapshot => _snapshot;
  static AsyncSnapshot<bool>? _snapshot;

  final Widget? loadingScreen;

  @override
  Widget build(BuildContext context) {
    Assets.init(context);
//    _context = context;
    return FutureBuilder<bool>(
      future: initAsync(),
      initialData: false,
      builder: (_, snapshot) {
        _snapshot = snapshot;
        return _asyncBuilder(snapshot, loadingScreen);
      },
    );
  }

  /// Runs all the asynchronous operations necessary before the app can proceed.
  @override
  Future<bool> initAsync() async {
    var init = true;
    if (v.App.hotReload) {
      _vw = createView();
      _vw?.con?.initApp();
    } else {
      // Initialize System Preferences
      await Prefs.init();
      // Collect installation & connectivity information
      await _app.initInternal();
      // If not running on the Web.
      if (!kIsWeb) {
        await v.App.getDeviceInfo();
      }
      // Initiate multi-language translations.
      await v.I10n.initAsync();
      // Set the App's theme.
      v.App.setThemeData();

      init = await super.initAsync();

      if (init) {
        _vw = createView();
        // Supply the state object to the App object.
        init = _app.setAppState(_vw);
        if (init) {
          init = (await _vw?.initAsync())!;
        }
        if (init) {
          _vw?.con?.initApp();
        }
      }
    }
    return v.App.isInit = init;
  }

  /// Clean up resources before the app is finally terminated.
  @mustCallSuper
  @override
  void dispose() {
    Prefs.dispose();
    // Assets.init(context); called in App.build() -gp
    Assets.dispose();
    //
    _app.dispose();
    super.dispose();
  }

  /// Run the CircularProgressIndicator() until asynchronous operations are
  /// completed before the app proceeds.
  Widget _asyncBuilder(AsyncSnapshot<bool> snapshot, Widget? loading) {
    if (snapshot.hasError) {
      final dynamic exception = snapshot.error;
      final details = FlutterErrorDetails(
        exception: exception,
        stack: exception is Error ? exception.stackTrace : null,
        library: 'app_statefulwidget',
        context: ErrorDescription('While getting ready in FutureBuilder Async'),
      );
      var handled = false;
      if (_vw != null) {
        handled = _vw!.onAsyncError(details);
      }
      if (!handled) {
        _app.onAsyncError(snapshot);
      }
      return v.App.errorHandler!.displayError(details);
    } else if (snapshot.connectionState == ConnectionState.done) {
      // If snapshot doesn't have data or is false, let the developer's app handle it.
//        && snapshot.hasData && snapshot.data) {
      return const v.AppStateWidget();
    } else {
      Widget widget;
      if (loading != null) {
        widget = loading;
      } else {
        if (UniversalPlatform.isAndroid) {
          widget = const Center(child: CircularProgressIndicator());
        } else {
          widget = const Center(child: CupertinoActivityIndicator());
        }
      }
      return widget;
    }
  }
}

/// Obtains [Controllers<T>] from its ancestors and passes its value to [builder].
///
class ConConsumer<T extends ControllerMVC> extends StatelessWidget {
  const ConConsumer({
    Key? key,
    required this.builder,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  /// The builder
  final Widget Function(BuildContext context, T? controller, Widget? child)
      builder;

  /// The child widget to pass to [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) => v.SetState(
      builder: (context, object) => builder(
            context,
            AppStatefulWidget._vw?.controllerByType<T>(),
            child,
          ));
}
