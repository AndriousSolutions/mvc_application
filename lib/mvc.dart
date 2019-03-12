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
///          Created  31 Dec 2018
///
///

export 'package:mvc_application/app.dart';

export 'package:mvc_application/model.dart';
export 'package:mvc_application/src/model/mvc.dart' show ModelMVC;

export 'package:mvc_application/view.dart' hide ViewMVC;
export 'package:mvc_application/src/view/mvc.dart' show ViewMVC;

export 'package:mvc_application/controller.dart';


import 'package:flutter/material.dart'
    show
        BuildContext,
        Key,
        StatelessWidget,
        Widget;

import 'package:mvc_application/app.dart' show App;

import 'package:mvc_application/view.dart' show AppView;

/// Passed to runApp() but calls App()
class MVC extends StatelessWidget {
  MVC(
    this.view, {
    this.key,
  }) : super();
  final AppView view;
  final Key key;

  Widget build(BuildContext context) => App(view, key: key);
}


