## 5.3.4
 July 04, 2020
- useMaterial = !switchUI &&

## 5.3.3
 June 29, 2020
- App.init() if (App?.themeData == null) {

## 5.3.2
 June 27, 2020
- ColorPicker.color = App.themeData.primaryColor;

## 5.3.1
 June 24, 2020
- Replace 'dart:io' to allow for Web apps.
- import 'package:universal_platform/universal_platform.dart';

## 5.3.0
 June 11, 2020
- final ThemeData theme; final CupertinoThemeData iOSTheme; deprecate getThemeData();

## 5.2.0
 June 07, 2020
- Renamed App.theme to App.themeData; _errorHandler.init(); removed App.colorTheme; AppMenu.init();

## 5.1.2
 June 03, 2020
- Corrected Apache Licence

## 5.1.1
 May 29, 2020
- errorHandler.reportError, errorHandler.runZonedError, errorHandler.isolateError

## 5.1.0
 May 18, 2020
- Replaced runZoned() with runZonedGuarded()
- class DataFields in field_widgets.dart

## 5.0.1
 May 18, 2020
- ConnectivityListener test for null

## 5.0.0 
 May 18, 2020
- Removed Controllers.of() from app.dart
- mvc_pattern: ^6.0.0
- Hide AppConMVC from mvc_pattern.dart

## 4.0.1
 May 16, 2020
- Uncomment show_cupertino_date_picker.dart

## 4.0.0
 May 09, 2020
- Renamed class Consumer to ConConsumer not be interfere with library package, Provider.
- Replace deprecated subhead to subtitle1 in DialogBox.dart
- Renamed Item to DataFieldItem in fields_widgets.dart.
- Renamed ten library files to conform to naming conventions.

## 3.0.1
 May 06, 2020
- Changed onSaved: (String v) in fields_widgets
- App._hotReload made private
 
## 3.0.0
 April 24, 2020
- Removed export files app.dart & mvc.dart
- Test extensively for null parameters
- Supply Object parameter to AppView
- Export Material.dart and Cupertino.dat in model.dart, view.dart and controller.dart.
- Uncomment DialogBox.dart due to Pub.dev bug.
- New getter vw in class App
- New properties in AppView: useMaterial, useCupertino and switchUI

## 2.0.2
 April 23, 2020
- Removed DialogBox.dart and showCupertinoDatePicker.dart to fix pub.dev bug.

## 2.0.1
 April 23, 2020
- DialogBox.dart return 'Future<bool>'
- app.dart removed 'I10n' and 'ErrorHandler'
 
## 2.0.0
 April 21, 2020
- Removed the packages, dbutils, i10n_translator, firebase_remote_config, android_alarm_manager
- Removed all dependencies to Firebase
    
## 1.9.0
 April 21, 2020
- Introduced the mixin HandleError
- Replaced the class AlarmManager with flutter_local_notifications
- Introduced Future<bool> initAsync() async in class App
- Introduced CupertinoActivityIndicator() in class _App
- Introduced new class ScheduleNotifications

## 1.8.0
- Better Error Handling integration
- runApp(); 
- AppController onError(FlutterErrorDetails details); 
- App _errorHandler = v.ErrorHandler(); 
- AppView onError(FlutterErrorDetails details);
- AppViewState _errorHandler = v.ErrorHandler();
- AppMenu if (App.useMaterial);
- showBox if (App.useMaterial);
- class StringCrypt

## 1.7.1
- Format source code
- Update README.md

## 1.7.0
- Include the library file, alarm_manager.dart, to provide the class, AlarmManager

## 1.6.1
- Prepare for 1.0.0 version of sensors and package_info. 
([dart_lsc](http://github.com/amirh/dart_lsc))

## 1.6.0
 March 13, 2020
- intro plugin android_alarm_manager with alarm_manager.dart
- intro App.hasError
- privatized AppView._useMaterial, AppView._useCupertino
 
## 1.5.0
 February 29, 2020
- CupertinoApp, showAboutDialog(), foundation.dart' show kIsWeb;

## 1.4.1
 January 19, 2020
- AppError(snapshot.error).home is returned when error

## 1.4.0
 January 16, 2020
- controllerByType()
- setState() allowed at times.
- import 'package:i10n_translator/i10n.dart';
- ErrorWidgetBuilder errorScreen
- static void catchError(Exception ex)
- themeMode: themeMode
- introduce VariableString.dart, custom_raised_button.dart', NavBottomBar.dart

## 1.3.0
 October 21, 2019
- Introduced package:i10n_translator
- Removed default: this.supportedLocales = const <Locale>[const Locale('en', 'US')]
- Included LocaleListResolutionCallback localeListResolutionCallback;

## 1.2.0
 September 20, 2019
- Provide List<ControllerMVC> controllers in AppView
- class Controllers.of<T extends ControllerMVC>([BuildContext context, listen = true]) {
- Widget buildView(BuildContext context) {
- class SetState and class Consumer

## 1.1.1
 August 23, 2019
- Add assert to SetState class

## 1.1.0
 August 23, 2019
- Remove setter from App.theme
- Introduce class StateMVC and ControllerMVC in App
- New function refresh() in view/App
- InheritedWidget to AppView class
- SetState class in App
- Introduce static PopupMenuButton<dynamic> show(StateMVC state, Menu menu)

## 1.0.6
 August 13, 2019
- ThemeData onTheme() => App.theme;
- _theme ??= await App.getThemeData();

## 1.0.5
 August 10, 2019
- super.initApp(); in App class

## 1.0.4
 July 21, 2019
- Lengthen description in pubspec.yaml
- AppMenu.show(StateMVC state) in appmenu.dart
- Remove reference to AppConMVC DeviceInfo and Theme in app.dart
 
## 1.0.3
 July 21, 2019
- Removed export 'package:sqflite/sqflite.dart';
- Add sqflite: ^1.1.6+2
- Add constraints in pubspec.yaml
- Supply links to README.md

## 1.0.2
 July 17, 2019
- export 'package:prefs/prefs.dart' show Prefs;

## 1.0.1
 July 17, 2019
- Class App now in mvc_application/src/view/app.dart

## 1.0.0
 July 16, 2019
- Initial release to pub.dev

## 0.15.2
 2019-03-19:
- Supply the AsyncSnapshot in App.snapshot

## 0.15.1
 2019-03-17: 
- final Widget loadingScreen;
- uxutils.git in pubspec.yaml
- Comment out _applicationParameters

## 0.15.0
 2019-03-15: 
- Add named parameter loadingScreen

## 0.14.3
 2019-03-12: 
- Moved ViewMVC to view/mvc.dart  
- Moved ModelMVC to model/mvc.dart
- Update export file, mvc.dart  

## 0.14.2 
 2019-03-09: 
- factory App(AppView view  

## 0.14.1 
 2019-03-08: 
- dartfmt and show directive all code

## 0.14.0 
  2019-03-07: 
- get isInit; AndroidX dependencies

## 0.13.0 
  2019-03-01: 
- prefs: library package


## 0.12.1 
  2019-02-27: 
- 'package:mvc_application/src/controller/app.dart' show App, AppController;

## 0.12.0 
  2019-02-27: 
- delete export 'src/controller/app.dart';

## 0.11.0 
  2019-02-22: 
- Rename class AppView to AppViewState; AppState to AppView

## 0.10.0 
  2019-02-20: 
- class App extends AppMVC { class ViewMVC extends AppState {

## 0.9.1 
  2019-02-16: 
- mvc_pattern: in pubspec.yaml

## 0.9.0 
  2019-02-14: 
- static String get appName => _packageInfo.appName; await DeviceInfo.init(); Introduced DeviceInfo


## 0.8.1 
  2019-02-10: 
- showAboutDialog(); PackageInfo.fromPlatform(); show Prefs; 

## 0.7.4 
  2019-02-09: 
- Color Theme Menu Popup

## 0.7.3 
  2019-02-09: 
- await Prefs.init(); get colorTheme => AppMenu.colorTheme;

## 0.7.2 
  2019-02-06: 
- class FieldWidgets<T> extends Item {

## 0.7.1 
  2019-02-06: 
- Removed class ConMVC, SDK Constraint to <3.0.0, keys() in class Item

## 0.6.0 
  2019-01-28: 
- Renamed the classes Controller and View to ConMVC and ViewMVC

## 0.5.0 
  2019-01-28: 
- if (_firstCon == null) _firstCon = this;  get inDebugger in class App 

## 0.4.0 
  2019-01-25: 
- factory _App({AppConMVC con, Key key}) {

## 0.3.0 
  2019-01-17: 
- Moved the class, Controller, into mvc.dart.

## 0.2.0
 2019-01-17: 
- class AppView extends StateMVC Highlights UI while debugging.

## 0.1.7 
 2019-01-16: 
-  _App  super(con: null, key: key);
- controller.dart  export show StateListener;
- fields.dart  DefaultTextStyle get defaultTextStyle
- mvc.dart  MVC(AppView view, {Key key})  View() this.add(con);

## 0.1.2 
 2019-01-06: 
- Introduced the class, Field

## 0.1.1
 2019-01-03: 
- export statements finalized.

## 0.1.0 
  2018-12-24: 
- Initial Development Release