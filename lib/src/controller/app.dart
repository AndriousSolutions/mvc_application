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
///          Created  24 Dec 2018
///

import 'dart:async' show Future;

import 'package:flutter/material.dart' show mustCallSuper;

import 'package:mvc_application/app.dart' show AppConMVC;

import 'package:mvc_application/controller.dart' show DeviceInfo;

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_application/view.dart' show StateMVC;

import 'package:mvc_application/controller.dart' show Assets;

import 'package:prefs/prefs.dart' show Prefs;

class AppController extends ControllerMVC implements AppConMVC {
  AppController([StateMVC state]) : super(state);

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  void initApp() {}

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the _App.init() function.
  @mustCallSuper
  Future<bool> init() async {
    await Prefs.init();
    await DeviceInfo.init();
    return Future.value(true);
  }

  /// Ensure certain objects are 'disposed.'
  /// Callec by the AppState.dispose() function.
  @override
  @mustCallSuper
  void dispose() {
    Prefs.dispose();

    /// Assets.init(context); called in App.build() -gp
    Assets.dispose();
    super.dispose();
  }
}

class ControllerMVC extends mvc.ControllerMVC {
  ControllerMVC([StateMVC state]) : super(state);
}
