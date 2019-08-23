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
        Text,
        showAboutDialog;

import 'package:mvc_application/view.dart' show App, ColorPicker, StateMVC;

import 'package:mvc_application/controller.dart' show Prefs;

class AppMenu {
  static StateMVC _state;
  static Menu _menu;

  static PopupMenuButton<dynamic> show(StateMVC state, [Menu menu]) {
    _state = state;
    _menu = menu;

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
            onChange: AppMenu.onChange);
        break;
      case 'About':
        showAboutDialog(
            context: _state.context,
            applicationName: "Greg's App Example",
            applicationVersion: App.version + '  buld: ${App.buildNumber}',
            children: [Text('A simple contact app demonstration.')]);
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
  void onSelected(dynamic menuItem);

  PopupMenuButton<dynamic> show(StateMVC state) {
    this.state = state;
    return AppMenu.show(state, this);
  }

  StateMVC state;
}
