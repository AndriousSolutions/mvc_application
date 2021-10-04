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

import 'package:flutter/foundation.dart' show FlutterErrorDetails;

import 'package:mvc_application/controller.dart' show HandleError;

import 'package:mvc_application/view.dart' as v
    show App, ConnectivityListener, ConnectivityResult, StateMVC;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

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
