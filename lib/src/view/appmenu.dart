///
/// Copyright (C) 2019 Andrious Solutions
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
///          Created  09 Feb 2019
///
///
import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        ColorSwatch,
        FloatingActionButtonThemeData,
        PopupMenuButton,
        PopupMenuDivider,
        PopupMenuEntry,
        PopupMenuItem,
        showAboutDialog,
        Text,
        ThemeData,
        Widget;

import 'package:mvc_application/view.dart' show App, ColorPicker, StateMVC;

import 'package:mvc_application/controller.dart' show Prefs;

class AppMenu {
  factory AppMenu() => _this ??= AppMenu._();
  AppMenu._();
  static AppMenu _this;

  static StateMVC _state;

  Menu _menu;
  String _applicationName;
  String _applicationVersion;
  Widget _applicationIcon;
  String _applicationLegalese;
  List<Widget> _children;

  PopupMenuButton<dynamic> show(
    StateMVC state, {
    String applicationName,
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
    bool useRootNavigator = true,
    Menu menu,
  }) {
    _state = state;
    _menu = menu;
    _applicationName = applicationName;
    _applicationVersion = 'version: ${App.version} build: ${App.buildNumber}';
    _applicationIcon = applicationIcon;
    _applicationLegalese = applicationLegalese;
    _children = children;

    List<PopupMenuEntry<dynamic>> menuItems = [
      PopupMenuItem<dynamic>(value: 'Color', child: ColorPicker.title),
      const PopupMenuItem<dynamic>(value: 'About', child: Text('About'))
    ];

    if (_menu != null) {
      final List<PopupMenuEntry<dynamic>> temp = [
        ..._menu.menuItems(),
        const PopupMenuDivider(),
        ...menuItems
      ];
      menuItems = temp;

      if (_menu.tailItems.isNotEmpty) {
        menuItems.add(const PopupMenuDivider());
        menuItems.addAll(_menu.tailItems);
      }
    }

    return PopupMenuButton<dynamic>(
      onSelected: _showMenuSelection,
      itemBuilder: (BuildContext context) => menuItems,
    );
  }

  void _showMenuSelection(dynamic value) {
    if (_menu != null) {
      _menu.onSelected(value);
    }
    if (value is! String) {
      return;
    }
    // Set the current colour.
    ColorPicker.color = App.themeData.primaryColor;
    switch (value) {
      case 'Color':
        ColorPicker.showColorPicker(
            context: _state.context,
            onColorChange: AppMenu.onColorChange,
            onChange: AppMenu.onChange,
            shrinkWrap: true);
        break;
      case 'About':
        showAboutDialog(
            context: _state.context,
            applicationName: _applicationName ?? App?.vw?.title ?? '',
            applicationVersion: _applicationVersion,
            applicationIcon: _applicationIcon,
            applicationLegalese: _applicationLegalese,
            children: _children);
        break;
      default:
    }
  }

  static void onColorChange(Color value) {
    /// Implement to take in a color change.
  }

  static void onChange([ColorSwatch value]) {
    //
    if (value == null) {
      final swatch = Prefs.getInt('colorTheme', -1);
      // If never set in the first place, ignore
      if (swatch > -1) {
        value = ColorPicker.colors[swatch];
        ColorPicker.colorSwatch = value;
      }
    } else {
      Prefs.setInt('colorTheme', ColorPicker.colors.indexOf(value));
    }

    /// Assign the colour to the floating button as well.
    App.themeData = ThemeData(
      primaryColor: value,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: value,
      ),
    );

    App.iOSTheme = value;

    // Rebuild the state.
    _state?.refresh();
  }
}

abstract class Menu {
  Menu() : _appMenu = AppMenu();
  final AppMenu _appMenu;

  //
  List<PopupMenuItem<dynamic>> tailItems = [];
  // abstract
  List<PopupMenuItem<dynamic>> menuItems();
  // abstract
  void onSelected(dynamic menuItem);

  PopupMenuButton<dynamic> show(StateMVC state, {String applicationName}) {
    this.state = state;
    return _appMenu.show(
      state,
      applicationName: applicationName,
      menu: this,
    );
  }

  StateMVC state;
}
