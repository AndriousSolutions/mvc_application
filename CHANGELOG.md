
## 8.2.1
 November 28, 2021
- Properly clean up memory
- _app?.dispose();
- _appState = null;
- _vw = null;

## 8.2.0
 November 24, 2021
- void inheritWidget(BuildContext context) => mvc.AppStateMVC.inheritWidget(context);

## 8.1.0+02
 November 11, 2021
- Updated README.md

## 8.1.0
 November 11, 2021
- Supplied an example app
- ..initialValue = item.value

## 8.0.1
 November 10, 2021
- itemsObj.value = '';

## 8.0.0
 October 30, 2021
- @Deprecated('No need to replace the initState() function. Use initState()')
    void initApp() {}
- class AppController extends ControllerMVC implements mvc.AppControllerMVC, v.ConnectivityListener {
- class AppState<T extends mvc.AppStatefulWidgetMVC> extends _AppState<T> {
-  // Listen to the device's connectivity.
   v.App.addConnectivityListener(con);
- /// The widget passed to runApp().
  abstract class AppMVC extends StatelessWidget {
- v.AppState createView(); to v.AppState createState();
- class AppStatefulWidget extends v.AppStatefulWidgetMVC {
- Removed string_encryption.dart;
- pedantic 1.11.1 (discontinued replaced by lints)
- class FieldWidgets<T> extends DataFieldItem with StateGetter {

## 7.11.0+2
 October 29, 2021
- Padding(padding: const EdgeInsets.symmetric(horizontal: 30),child: trailing)

## 7.11.0
 October 24, 2021
- static ColorSwatch<int?>? setThemeData([ColorSwatch<int?>? value]) {
- bool? captureInheritedThemes;
- final LocaleListResolutionCallback? inLocaleListResolutionCallback;
- final LocaleResolutionCallback? inLocaleResolutionCallback;
- v.App.themeData ??= ThemeData.light();
- color: color ?? onColor() ?? Colors.blue,
- inLocaleResolutionCallback ?? v.I10n.localeResolutionCallback;
- //    title ??= '';
- //    color ??= Colors.blue;
- v.App.setThemeData();
- class ISOSpinner extends StatefulWidget {
- static void snackBar({
- context: App.context!,

## 7.10.0
 October 17, 2021
- package_info_plus: ^1.0.0

## 7.9.2
 October 08, 2021
- if (snapshot.hasError || (v.App.isInit != null && !v.App.isInit!)) {

## 7.9.1
 October 08, 2021
- (v.App.isInit != null && v.App.isInit!)

## 7.9.0
 September 28, 2021
- run_app.dart and run_webapp.dart

## 7.8.1
 September 15, 2021
- Future<bool?> showBox({ to Future<bool> showBox({

## 7.8.0
 September 09, 2021
- RouterDelegate `New Route Navigation`
- Migrating from `device_info` plugin to `device_info_plus`
- flutter_local_notifications from ^6.0.0 to ^8.0.0
- List<Map<String, dynamic>?> mapItems to List<Map<String, dynamic>> mapItems

## 7.7.1+2
 August 03, 2021
- Migrate from the `connectivity` plugin to `connectivity_plus`.
- Corrected schedule_notifications.dart

## 7.7.0
 July 08, 2021
- StateMVC.of<T>(context);

## 7.6.1
 June 21, 2021
- Empty _items = [{}];
- universal_platform: ^1.0.0+1

## 7.6.0
 June 16, 2021
- restorationScopeId & scrollBehavior for MaterialApp and CupertinoApp

## 7.5.0
 June 12, 2021
- connectivity 3.0.6 (was 3.0.4)
- device_info 2.0.2 (was 2.0.1)
- ffi 1.1.2 (was 1.0.0)
- flutter_native_timezone 1.1.0 (2.0.0 available)
- mvc_pattern 7.3.0+2 (was 7.2.0)
- package_info 2.0.2 (was 2.0.0)
- path_provider 2.0.2 (was 2.0.1)
- shared_preferences 2.0.6 (was 2.0.5)
- url_launcher 6.0.6 (was 6.0.4)
- url_launcher_web 2.0.1 (was 2.0.0)
- win32 2.1.5 (was 2.1.1)

## 7.4.0
 May 24, 2021
- connectivity 3.0.4 (was 3.0.3)
- device_info 2.0.1 (was 2.0.0)
- file 6.1.1 (was 6.1.0)
- flutter_local_notifications 6.0.0 (was 5.0.0)
- url_launcher 6.0.4 (was 6.0.3)
- win32 2.1.1 (was 2.0.5)

## 7.3.0
 May 12, 2021
- flutter_material_color_picker incompatible to null safety
- Corrected the README.md examples

## 7.2.0
 May 05, 2021
- Commented out flutter_string_encryption (too old)
- this.useMaterial,
  this.useCupertino,
  this.switchUI,

## 7.1.0
 March 28, 2021
- Removed deprecated snapshot getter
- Introduced iso_spinner.dart
- Remove getThemeData() & setThemeData() in app.dart
- v.App.themeData = theme ?? ThemeData.light();
- rethrow an App.initAsync() error
- _fillRecords(); to fillRecords();
- final T? object; to T? object; in FieldWidgets<T>

## 7.0.2-nullsafety
 March 10, 2021
- i10n_translator: ^2.0.0

## 7.0.1-nullsafety
 March 10, 2021
- 'App' cannot be null replacing '?.' with '.'

## 7.0.0-nullsafety
 March 10, 2021
- Null safety 2.12.0
- Removed example app

## 6.12.0
 March 05, 2021
- Localizations.maybeLocaleOf(context);
- ScaffoldMessenger.maybeOf(context);
- PopupMenuButton(captureInheritedThemes: true);
- m.Material( in field_widgets.dart


## 6.11.0+3
 January 25, 2021
- bool setAppStatefulWidget()
- static BuildContext get context => _appWidget.context;
- _app.addConnectivityListener(con); _app.initInternal();
- m.Material(child: m.TextFormField(
- Widget get listTile => App.useCupertino ? CupertinoListTile(
- return Material(child: DropdownButton<String>(
- file format

## 6.10.2
 January 13, 2021
- Supply a range to pre-release dependencies '>=0.1.0 <1.0.0'

## 6.10.1
  January 12, 2021
- abstract class AppPopupMenu<T>;
- key: key ?? this.key,
- timezone: ^0.5.0

## 6.10.0
  January 10, 2021
- Allow for popup menu on iOS: popupMenu = Material(child: popupMenu);

## 6.9.1
  January 09, 2021
- app_menu.dart' show AppMenu, AppPopupMenu

## 6.9.0
  January 09, 2021
- Introduced class AppPopupMenu<T>

## 6.8.1
  January 09, 2021
- Renamed parameters errorHandler, errorScreen, errorReport in controller/app.dart

## 6.8.0
  January 09, 2021
- consistency naming of named parameters: errorHandler, errorScreen, errorReport

## 6.7.0
  December 09, 2020
- flutter analyze with pedantic: ^1.10.0-nullsafety.3
- No annotation of local variables
- Removed named parameter, nullOK from Scaffold.of(context);

## 6.6.0
  December 06, 2020
- Further documentation
- Finalize variables in app_state.dart
- No longer using deprecated autovalidate from TextFormField

## 6.5.2
  November 26, 2020
- Updated device_info: ^0.4.0

## 6.5.1
  November 21, 2020
- home: home ?? onHome(); Introduced function for named-parameter, home.

## 6.5.0
  November 15, 2020
- Allow interface switching.
- merge DefaultMaterialLocalizations.delegate & I10nDelegate()

## 6.4.0
  November 10, 2020
- New parameter allowNewHandlers in AppErrorHandler

## 6.3.0
  November 09, 2020
- New method onAsyncError(FlutterErrorDetails details)
- App-level & Async error handling
- Deprecated getter, snapshot.
- Deprecated ErrorHandler for AppErrorHandler

## 6.2.1
  November 07, 2020
- Corrected some named-parameters from 'reportError' to 'errorReport'

## 6.2.0
  November 07, 2020
- Class ErrorHandler is deprecated replaced by class AppErrorHandler
- Many more error handler setters and getters.
- App class object now has reference to the error handler.
- Renamed AppState.reportError to AppState.errorReport.
- Updated to latest plugin, FlutterLocalNotificationsPlugin

## 6.1.0
  November 02, 2020
- 25 new 'MaterialApp & CupertinoApp property methods' in the class, AppState
- new method, App.setThemeData();
- new method, AppMenu.setThemeData();

## 6.0.0
  October 29, 2020
- sdk: ">=2.10.0 <3.0.0"
- Separate the MVC components to individual dart files:
  app_statefulwidget.dart, app_state.dart, app.dart and app_menu.dart
- Renamed class, App, to AppStatefulWidget and in file, app_statefulwidget.dart
- Renamed class, AppView, to AppState and in file, app_state.dart.
- New separate class, App, in the file, app.dart.
- In dialog_box.dart, switch the push buttons around.
- Introduce dependency, flutter_localizations:, to support for other languages.
- Introduce dependency, url_launcher_web: ^0.1.0, for web support

## 5.13.0+2
  October 17, 2020
- switchButtons in class _DialogWindow
- update README.md

## 5.13.0
 October 16, 2020
- Incorporate text translation with package, I10n_translator 
- Removed the second MaterialApp()
- Removed AppError().home;
- App.changeUI(String ui);
- Enhanced getter App.locale
- Corrected theme: property
- Enhance dialog_box.dart
- Update field_widgets.dart
- Update schedule_notifications.dart and flutter_local_notifications: ^2.0.0
- Removed deprecated properties: materialKey, getThemeData() and setThemeData()
- Introduced the IOS-style interface feature: tab_buttons.dart
- Introduced timezone.dart with plugin, flutter_native_timezone.

## 5.12.0
 October 02, 2020
- Conditional export of runApp()
- Removed deprecated materialKey in view/app.dart

## 5.11.2
 October 02, 2020
- missing LocaleListResolutionCallback
- FloatingActionButtonThemeData to AppMenu class

## 5.11.1
 September 18, 2020
- Utilize App.refresh();
- flutter_local_notifications: ^1.0.0

## 5.11.0
 September 16, 2020
- New field, type, in class, DataFieldItem
- Removed from example app fields, prefix, suffix, street, city, region, postcode & country
- one2Many(), mapItems() in field_widgets.dart
- Corrected version number in README.md

## 5.10.0
 September 07, 2020
- New embedded Android version
- New example app
- Replaced _App.show with _asyncBuilder()
- initAsync() calls Prefs.init(), _getThemeData() and createView()
- _AppWidget changed to _AppStatefulWidget
- export 'package:pedantic/pedantic.dart' show unawaited;
- Default colour Colors.blue instead of Colors.white

## 5.9.0
 July 14, 2020
- Strict Flutter Lint Rules following Dart Style Guide.
- Introduced analysis_options.yaml

## 5.8.0
 July 10, 2020
- static set themeData(dynamic value) 
- v.AppMenu.onChange();

## 5.7.0
 July 09, 2020
- @deprecated materialKey; 
- (UniversalPlatform.isIOS && switchUI); 
- @deprecated Widget buildView(BuildContext context)

## 5.6.0
 July 08, 2020
- void addField(); String get errorText

## 5.5.0
 July 06, 2020
- Provide a Form's Stat object: Widget linkForm(child) => _ChildForm(parent: this, child: child);
- git rm --cached -r .pubspec.lock

## 5.4.2
 July 05, 2020
- (switchUI && !useCupertino && !useMaterial);

## 5.4.1
 July 04, 2020
- (UniversalPlatform.isAndroid && !switchUI)

## 5.4.0
 July 04, 2020
- updated .gitignore

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
