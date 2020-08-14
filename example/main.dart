// https://github.com/fluttercommunity/flutter_contacts/tree/master/example
// https://pub.dartlang.org/packages/contacts_service#-readme-tab-

import 'package:flutter/material.dart' show Key, runApp;

import 'package:mvc_application/view.dart' show App, AppView;

import 'view.dart' show ContactsExampleApp;

void main() => runApp(MyApp());

class MyApp extends App {
  MyApp({Key key}):super(key: key);
  @override
  AppView createView() => ContactsExampleApp();
}
