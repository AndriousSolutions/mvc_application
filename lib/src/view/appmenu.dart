///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
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
        PopupMenuButton,
        PopupMenuDivider,
        PopupMenuEntry,
        PopupMenuItem,
        showAboutDialog,
        Text,
        Widget;

import 'package:mvc_application/view.dart' show App, ColorPicker, StateMVC;

import 'package:mvc_application/controller.dart' show Prefs;

class AppMenu {
  static StateMVC _state;
  static Menu _menu;
  static Menu _tail;
  static String _applicationName;
  static String _applicationVersion;
  static Widget _applicationIcon;
  static String _applicationLegalese;
  static List<Widget> _children;

    static PopupMenuButton<dynamic> show(StateMVC state, {
    String applicationName = "Name of you app.",
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
    bool useRootNavigator = true,
    Menu menu,
    }) {
    _state = state;
    _menu = menu;
    _applicationName = applicationName;
    _applicationVersion = "version: ${App.version} build: ${App.buildNumber}";
    _applicationIcon = applicationIcon;
    _applicationLegalese = applicationLegalese;
    _children = children;

    List<PopupMenuEntry<dynamic>> menuItems = [
      PopupMenuItem<dynamic>(value: 'Color', child: ColorPicker.title),
      const PopupMenuItem<dynamic>(value: 'About', child: Text('About')),
    ];

    if (_menu != null) {
      List<PopupMenuEntry<dynamic>> temp = [];
      temp.addAll(_menu.menuItems());
      temp.add(PopupMenuDivider());
      temp.addAll(menuItems);
      menuItems = temp;

      if(_menu.tailItems.isNotEmpty){
        menuItems.add(PopupMenuDivider());
        menuItems.addAll(_menu.tailItems);
      }
    }

    return PopupMenuButton<dynamic>(
      onSelected: _showMenuSelection,
      itemBuilder: (BuildContext context) => menuItems,
    );
  }

  static _showMenuSelection(dynamic value) {
    if (_menu != null) {
      _menu.onSelected(value);
    }
    if (value is! String) return;
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
            applicationName: _applicationName,
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

  static void onChange(ColorSwatch value) {
    Prefs.setInt('colorTheme', ColorPicker.colors.indexOf(value));

    /// Rebuild the state.
    _state.refresh();
  }

  static ColorSwatch get colorTheme {
    final theme = Prefs.getInt('colorTheme');
    ColorPicker.colorSwatch = ColorPicker.colors[theme];
    return ColorPicker.colorSwatch;
  }
}

abstract class Menu {
  List<PopupMenuItem<dynamic>> menuItems();
  List<PopupMenuItem<dynamic>> tailItems = [];
  void onSelected(dynamic menuItem);

  PopupMenuButton<dynamic> show(StateMVC state, {String applicationName}) {
    this.state = state;
    return AppMenu.show(state, applicationName: applicationName, menu: this,);
  }

  StateMVC state;
}
