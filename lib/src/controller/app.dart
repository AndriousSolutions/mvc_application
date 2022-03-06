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
class AppController extends ControllerMVC implements v.ConnectivityListener {
  /// Optionally supply a 'State' object to be linked to this State Controller.
  AppController([v.StateMVC? state]) : super(state);

  /// Initialize any immediate 'none time-consuming' operations
  /// at the very beginning.
  @override
  @Deprecated('No need. Use initState()')
  void initApp() {}

  @override
  Future<bool> initAsync() async {
    /// Initialize any 'time-consuming' operations at the beginning.
    /// Initialize items essential to the Mobile Applications.
    /// Implement any asynchronous operations needed done at start up.
    return true;
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    /// Supply an 'error handler' routine if something goes wrong
    /// in the corresponding initAsync() routine.
    /// Returns true if the error was properly handled.
    return false;
  }

  /// The 'App Level' Error Handler.
  /// Override if you like to customize your error handling.
  void onError(FlutterErrorDetails details) {
    // Call the App's 'current' error handler.
    v.App?.onError(details);
  }

  /// If the device's connectivity changes.
  @override
  void onConnectivityChanged(v.ConnectivityResult result) {}
}

/// Your 'working' class most concerned with the app's functionality.
/// Incorporates an Error Handler.
class ControllerMVC extends mvc.ControllerMVC with HandleError {
  /// Optionally supply a 'State' object to be linked to this State Controller.
  ControllerMVC([v.StateMVC? state]) : super(state);

  /// The current StateMVC object from mvc_application/view.dart
  v.StateMVC? get stateMVC => state as v.StateMVC?;

  // String addState(v.StateMVC? state) => super.addState(state as mvc.StateMVC);
}
