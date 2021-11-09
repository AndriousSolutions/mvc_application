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
///          Created  25 Dec 2018
///
///

// Material
export 'package:flutter/material.dart' hide runApp;

// Cupertino
export 'package:flutter/cupertino.dart' hide RefreshCallback, runApp;

// App
export 'package:mvc_pattern/mvc_pattern.dart' show StateListener;

// App's View
export 'package:mvc_application/src/view/app.dart' show App, AppDrawer;

//App's Controller
export 'package:mvc_application/src/controller/app.dart'
    show AppController, ControllerMVC;

// Error Handler
export 'package:mvc_application/src/controller/util/handle_error.dart'
    show HandleError;

// Notifications
export 'package:mvc_application/src/controller/schedule_notificaitons.dart';

// Device Info
export 'package:mvc_application/src/controller/device_info.dart'
    show DeviceInfo;

// Assets
export 'package:mvc_application/src/controller/assets/assets.dart';

// Preferences
export 'package:prefs/prefs.dart' show Prefs, SharedPreferences;
