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
- Lenghthen description in pubspec.yaml
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