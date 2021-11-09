///
/// Copyright (C) 2019 Andrious Solutions
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
///          Created  12 Mar 2019
///
///

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_application/view.dart' as v show StateMVC;

import 'package:mvc_application/controller.dart' show HandleError;

/// The Model for a simple app.
/// Incorporates an Error Handler.
class ModelMVC extends mvc.ModelMVC with HandleError {
  factory ModelMVC([v.StateMVC? state]) => _firstMod ??= ModelMVC._(state);
  ModelMVC._(v.StateMVC? state) : super(state);
  static ModelMVC? _firstMod;

  /// Allow for easy access to 'the first Model' throughout the application.
  // ignore: prefer_constructors_over_static_methods
  static ModelMVC get mod => _firstMod ?? ModelMVC();
}
