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
///          Created  20 Oct 2021
///
///

import 'package:flutter/services.dart';

import 'package:mvc_application/view.dart';

/// Landscape-only State object.
mixin SetOrientationLandscapeOnly<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    /// The empty list causes the application to defer to the system default.
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }
}

/// Portrait-only State object.
mixin SetOrientationPortraitOnly<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    /// The empty list causes the application to defer to the system default.
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }
}
