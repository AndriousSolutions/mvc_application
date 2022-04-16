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

/// Material
export 'package:flutter/material.dart' hide runApp;

/// Cupertino
export 'package:flutter/cupertino.dart' hide RefreshCallback, runApp;

/// Supply the custom runApp function
export 'package:mvc_application/src/conditional_export.dart'
    if (dart.library.html) 'package:mvc_application/src/view/platforms/run_webapp.dart'
    if (dart.library.io) 'package:mvc_application/src/view/platforms/run_app.dart'
    show runApp;

/// Replace 'dart:io' for Web applications
export 'package:universal_platform/universal_platform.dart';

/// Flutter Framework's Foundation
export 'package:flutter/foundation.dart' show kIsWeb, mustCallSuper, protected;

/// MVC
export 'package:mvc_pattern/mvc_pattern.dart'
    show AppStatefulWidgetMVC, InheritedStateMixin, InheritedStateMVC, SetState;

/// App
export 'package:mvc_application/src/view/app.dart';

/// App StatefulWidget
export 'package:mvc_application/src/view/app_statefulwidget.dart'
    hide ErrorWidgetBuilder;

/// App State Object
export 'package:mvc_application/src/view/app_state.dart';

/// Settings
export 'package:mvc_application/src/view/utils/app_settings.dart';

/// Error Handling
export 'package:mvc_application/src/view/utils/error_handler.dart'
    show AppErrorHandler, ReportErrorHandler;

/// Screens
export 'package:mvc_application/src/view/utils/loading_screen.dart';

/// Fields
export 'package:mvc_application/src/view/utils/field_widgets.dart';

/// Localiztions
export 'package:flutter_localizations/flutter_localizations.dart'
    show
        GlobalCupertinoLocalizations,
        GlobalMaterialLocalizations,
        GlobalWidgetsLocalizations;

/// TimeZone
export 'package:mvc_application/src/view/utils/timezone.dart';

/// InheritedWidget Widget
export 'package:mvc_application/src/view/utils/inherited_state.dart'
    show InheritedStates, InheritedStateWidget;

/// Menus
export 'package:mvc_application/src/view/app_menu.dart'
    show AppMenu, AppPopupMenu, Menu;

/// Router Navigation
export 'package:mvc_application/src/view/app_navigator.dart';

/// UX Utils
export 'package:mvc_application/src/view/uxutils/view.dart';

/// Preferences
export 'package:prefs/prefs.dart' show Prefs;

/// Translations
export 'package:l10n_translator/l10n.dart';
