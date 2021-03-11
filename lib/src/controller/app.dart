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

import 'dart:async' show runZonedGuarded;

import 'dart:isolate' show Isolate, RawReceivePort;

import 'package:flutter/material.dart' as m
    show ErrorWidgetBuilder, Widget, runApp;

import 'package:flutter/foundation.dart'
    show FlutterExceptionHandler, FlutterErrorDetails;

import 'package:mvc_application/controller.dart' show HandleError;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_application/view.dart' as v
    show
        App,
        ConnectivityListener,
        ConnectivityResult,
        AppErrorHandler,
        ReportErrorHandler,
        StateMVC;

/// Add an Error Handler right at the start.
void runApp(
  m.Widget app, {
  FlutterExceptionHandler? errorHandler,
  m.ErrorWidgetBuilder? errorScreen,
  v.ReportErrorHandler? errorReport,
  bool allowNewHandlers = false,
}) {
  // Instantiate the app's error handler.
  final handler = v.AppErrorHandler(
      handler: errorHandler,
      builder: errorScreen,
      report: errorReport,
      allowNewHandlers: allowNewHandlers);

  Isolate.current.addErrorListener(RawReceivePort((dynamic pair) {
    //
    if (pair is List<dynamic>) {
      final isolateError = pair;
      handler.isolateError(
        isolateError.first.toString(),
        StackTrace.fromString(isolateError.last.toString()),
      );
    }
  }).sendPort);

  // Catch any errors attempting to execute runApp();
  runZonedGuarded(() {
    m.runApp(app);
  }, handler.runZonedError);
}

/// A Controller for the 'app level'.
class AppController extends ControllerMVC implements mvc.AppConMVC {
  //
  AppController([v.StateMVC? state]) : super(state);

  /// Initialize any immediate 'none time-consuming' operations
  /// at the very beginning.
  @override
  void initApp() {}

  /// Override if you like to customize your error handling.
  @override
  void onError(FlutterErrorDetails details) {
    // Call the App's 'current' error handler.
    v.App?.onError(details);
  }
}

/// A Controller for the 'app level' to influence the whole app.
class AppConMVC extends mvc.AppConMVC with v.ConnectivityListener, HandleError {
  //
  AppConMVC([v.StateMVC? state]) : super(state);

  /// If the device's connectivity changes.
  @override
  void onConnectivityChanged(v.ConnectivityResult result) {}
}

/// Your 'working' class most concerned with the app's functionality.
/// Incorporates an Error Handler.
class ControllerMVC extends mvc.ControllerMVC with HandleError {
  //
  ControllerMVC([v.StateMVC? state]) : super(state);
}
