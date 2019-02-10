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
        PopupMenuItem,
        State,
        Text;

import 'package:mvc_application/controller.dart';

import 'package:uxutils/view.dart';

class AppMenu {
  static State _state;

  static PopupMenuButton<String> show(State state) {
    _state = state;
    return PopupMenuButton<String>(
      onSelected: _showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(value: 'Color', child: ColorPicker.title),
          ],
    );
  }

  static _showMenuSelection(String value) {
    switch (value) {
      case 'Color':
        ColorPicker.showColorPicker(
            context: _state.context,
            onColorChange: AppMenu.onColorChange,
            onChange: AppMenu.onChange);
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
    _state.setState(() {});
  }

  static ColorSwatch get colorTheme {
    ColorPicker.colorSwatch = ColorPicker.colors[Prefs.getInt('colorTheme')];
    return ColorPicker.colorSwatch;
  }
}
