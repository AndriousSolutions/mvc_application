///
///          Created  09 Feb 2019
///          Andrious Solutions
///

/// Import the interface
import 'package:mvc_application_example/src/view.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPicker {
  static Color get color => _color;
  static set color(Color? color) {
    if (color != null) {
      _color = color;
    }
  }

  static Color _color = Colors.red;

  static ColorSwatch<int?> get colorSwatch => _colorSwatch;
  static set colorSwatch(ColorSwatch<int?> swatch) {
    _color = swatch;
    _colorSwatch = swatch;
  }

  static ColorSwatch<int?> _colorSwatch = Colors.red;

  static bool allowShades = false;
  static double get circleSize => _circleSize;
  static set circleSize(double size) {
    if (size > 1.0) {
      _circleSize = size;
    }
  }

  static double _circleSize = 60;

  static IconData iconSelected = Icons.check;

  // ignore: avoid_setters_without_getters
  static set onColorChange(ValueChanged<Color> func) => _onColorChange = func;
  static ValueChanged<Color>? _onColorChange;

  // ignore: avoid_setters_without_getters
  static set onChange(ValueChanged<ColorSwatch<int?>> func) => _onChange = func;
  static ValueChanged<ColorSwatch<int?>>? _onChange;

  static List<ColorSwatch<int?>> get colors => Colors.primaries;

//  static Text title = const Text('Colour Theme');

  static Future<ColorSwatch<int>?> showColorPicker({
    required BuildContext context,
    ValueChanged<Color>? onColorChange,
    ValueChanged<ColorSwatch<int?>>? onChange,
    bool shrinkWrap = false,
  }) {
    return showDialog<ColorSwatch<int>>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(children: <Widget>[
        MaterialColorPicker(
          selectedColor: _color,
          onColorChange: (Color color) {
            _color = color;
            if (onColorChange != null) {
              onColorChange(color);
            }
            if (_onColorChange != null) {
              _onColorChange!(color);
            }
            Navigator.pop(context, color);
          },
          onMainColorChange: (ColorSwatch<dynamic>? color) {
            _color = color!;
            _colorSwatch = color as ColorSwatch<int?>;
            if (onChange != null) {
              onChange(color);
            }
            if (_onChange != null) {
              _onChange!(color);
            }
            Navigator.pop(context, color);
          },
          colors: colors,
          allowShades: allowShades, // default true
          iconSelected: iconSelected,
          circleSize: circleSize,
          shrinkWrap: shrinkWrap,
        ),
      ]),
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPicker && runtimeType == other.runtimeType;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => 0;
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}
