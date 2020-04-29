// https://github.com/fluttercommunity/flutter_contacts/tree/master/example
// https://pub.dartlang.org/packages/contacts_service#-readme-tab-

import 'package:flutter/material.dart' show runApp;

import 'package:mvc_application/view.dart' show App;

import 'view.dart' show ContactsExampleApp;

void main() => runApp(MyApp());

class MyApp extends App {
  @override
  createView() => ContactsExampleApp();
}
