///
/// Copyright (C) 2021 Andrious Solutions
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
///          Created  28 Sep 2021
///
import 'dart:async' show runZonedGuarded;

import 'dart:isolate' show Isolate, RawReceivePort;

import 'package:flutter/foundation.dart' show FlutterExceptionHandler;

import 'package:flutter/material.dart' as m
    show ErrorWidgetBuilder, Widget, runApp;

import 'package:mvc_application/view.dart' as v
    show AppErrorHandler, ReportErrorHandler;

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
