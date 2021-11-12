import 'dart:async' show Future;

import 'package:flutter/material.dart'
    show StatelessWidget, TextStyle, VoidCallback;

import 'package:mvc_application_example/src/view.dart' show AppSettings, Prefs;

class Settings {
  //
  static bool get(String? setting) {
    if (setting == null || setting.trim().isEmpty) {
      return false;
    }
    return Prefs.getBool(setting, false);
  }

  static Future<bool> set(String? setting, bool value) {
    if (setting == null || setting.trim().isEmpty) {
      return Future.value(false);
    }
    return Prefs.setBool(setting, value);
  }

  static bool getOrder() {
    return Prefs.getBool('order_of_items', false);
  }

  static Future<bool> setOrder(bool value) {
    return Prefs.setBool('order_of_items', value);
  }

  static bool getLeftHanded() {
    return Prefs.getBool('left_handed', false);
  }

  static Future<bool> setLeftHanded(bool value) {
    return Prefs.setBool('left_handed', value);
  }

  static StatelessWidget tapText(String text, VoidCallback onTap,
      {TextStyle? style}) {
    return AppSettings.tapText(text, onTap, style: style);
  }
}
