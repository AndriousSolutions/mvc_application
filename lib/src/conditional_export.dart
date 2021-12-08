///
/// Copyright (C) 2020 Andrious Solutions
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
///          Created  02 Oct 2020
///
///

/// Merely a 'stub' used by conditional import and export statements.

import 'package:flutter/material.dart' show ErrorWidgetBuilder, Widget;

import 'package:flutter/foundation.dart' show FlutterExceptionHandler;

import 'package:mvc_application/view.dart' show ReportErrorHandler;

/// Used in the conditional export statement:
/// Found in 'package:mvc_application/view.dart'
/// For example:
/// export 'package:mvc_application/src/conditional_export.dart'
/// if (dart.library.html) 'package:flutter/material.dart'
/// if (dart.library.io) 'package:mvc_application/src/controller/app.dart' show runApp;

/// This of course is fake. Merely to satisfy the Dart Analysis tool.
/// if (dart.library.html) 'package:mvc_application/src/view/platforms/run_webapp.dart'
/// if (dart.library.io) 'package:mvc_application/src/view/platforms/run_app.dart'
void runApp(
  Widget app, {
  FlutterExceptionHandler? errorHandler,
  ErrorWidgetBuilder? errorScreen,
  ReportErrorHandler? errorReport,
  bool allowNewHandlers = false,
}) {}
