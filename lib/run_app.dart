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

/// At times, you may need to explicitly supply the custom runApp function:
///
///       import 'package:mvc_application/run_app.dart';
///
/// Otherwise, it's supplied by the view.dart export file.
///
export 'package:mvc_application/src/conditional_export.dart'
    if (dart.library.html) 'package:mvc_application/src/view/platforms/run_webapp.dart'
    if (dart.library.io) 'package:mvc_application/src/view/platforms/run_app.dart'
    show runApp;
