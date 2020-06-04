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

import 'package:flutter/material.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPicker {
  static Color get color => _color;
  static set color(Color color) {
    if (color != null) _color = color;
  }

  static Color _color = Colors.red;

  static ColorSwatch get colorSwatch => _colorSwatch;
  static set colorSwatch(ColorSwatch swatch) {
    _color = swatch;
    _colorSwatch = swatch;
  }

  static ColorSwatch _colorSwatch = Colors.red;

  static bool allowShades = false;
  static double get circleSize => _circleSize;
  static set circleSize(double size) {
    if (size > 1.0) _circleSize = size;
  }

  static double _circleSize = 60.0;

  static IconData iconSelected = Icons.check;

  static set onColorChange(ValueChanged<Color> func) => _onColorChange = func;
  static ValueChanged<Color> _onColorChange;

  static set onChange(ValueChanged<ColorSwatch> func) => _onChange = func;
  static ValueChanged<ColorSwatch> _onChange;

  static List<ColorSwatch> get colors => Colors.primaries;

  static Text title = Text('Color Theme');

  static Future<ColorSwatch> showColorPicker({
    @required BuildContext context,
    ValueChanged<Color> onColorChange,
    ValueChanged<ColorSwatch> onChange,
    bool shrinkWrap = false,
  }) {
    return showDialog<ColorSwatch>(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(title: title, children: <Widget>[
              MaterialColorPicker(
                selectedColor: _color,
                onColorChange: (Color color) {
                  _color = color;
                  if (onColorChange != null) onColorChange(color);
                  if (_onColorChange != null) _onColorChange(color);
                  Navigator.pop(context, color);
                },
                onMainColorChange: (ColorSwatch color) {
                  _color = color;
                  _colorSwatch = color;
                  if (onChange != null) onChange(color);
                  if (_onChange != null) _onChange(color);
                  Navigator.pop(context, color);
                },
                colors: colors,
                allowShades: allowShades, // default true
                iconSelected: iconSelected,
                circleSize: circleSize,
                shrinkWrap: shrinkWrap,
              ),
            ]));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPicker && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}
