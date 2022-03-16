///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  19 Dec 2018
///
///

import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart' as m; //show TextFormField;

import 'package:flutter/services.dart'
    show
        Brightness,
        MaxLengthEnforcement,
        TextCapitalization,
        TextInputAction,
        TextInputFormatter,
        TextInputType;

import 'package:mvc_application/view.dart' hide TextFormField;

/// The 'On Save' Function
typedef OnSavedFunc = void Function<E>(E v);

/// Comprehensive Data Field Class
class DataFields<T> extends _AddFields<T> {
  @override
  Future<List<Map<String, dynamic>>> retrieve() async => [{}];

  @override
  Future<bool> add(Map<String, dynamic> rec) async => false;

  @override
  Future<bool> save(Map<String, dynamic> rec) async => false;

  @override
  Future<bool> delete(Map<String, dynamic> rec) async => false;

  @override
  Future<bool> undo(Map<String, dynamic> rec) async => false;

  FormState? _formState;

  ///
  Widget linkForm(Widget child) => _ChildForm<T>(parent: this, child: child);

  ///
  bool saveForm() {
    final save = _formState?.validate() ?? true;
    if (save) {
      _formState?.save();
    } else {
      _errorText = fieldErrors();
    }
    return save;
  }

  /// Retain an internal list of FormFieldState objects.
  final Set<FormFieldState<dynamic>> _fields = <FormFieldState<dynamic>>{};

  /// Add a FormFieldState object.
  void addField(FormFieldState<dynamic> field) {
    _fields.add(field);
  }

  /// Remove a FormFieldState object.
  void removeField(FormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  /// A collection of errors returned by the [FormField.validator]
  String? get errorText => _errorText;
  String? _errorText = ' ';

  /// True if this field has any validation errors.
  bool get hasError => _errorText != null;

  /// Any errors from every [FormField] that is a descendant of this [Form].
  String fieldErrors() {
    var errors = '';
    for (final field in _fields) {
      if (field.hasError) {
        errors = errors + field.errorText!;
      }
    }
    return errors;
  }
}

/// This class intercepts and retrieves the FormState
class _ChildForm<T> extends StatelessWidget {
  const _ChildForm({this.parent, this.child, Key? key}) : super(key: key);
  final DataFields<T>? parent;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    // Retrieve the Form's State object.
    parent!._formState = Form.of(context);
    return child!;
  }
}

abstract class _AddFields<T> extends _EditFields<T> {
  Future<bool> add(Map<String, dynamic> rec);
}

abstract class _EditFields<T> extends _ListFields<T> {
  /// The save record routine.
  Future<bool> save(Map<String, dynamic> rec);

  Future<bool> delete(Map<String, dynamic> rec);

  Future<bool> undo(Map<String, dynamic> rec);
}

abstract class _ListFields<T> {
  /// Retrieve the data fields from the data source into a List of Maps.
  Future<List<Map<String, dynamic>>> retrieve();

  /// List of the actual data fields.
  List<Map<String, dynamic>> get items => _items;
  List<Map<String, dynamic>> _items = [];

  /// Retrieve the to-do items from the database
  Future<List<Map<String, dynamic>>> query() async {
    _items = await retrieve();
    fillRecords(_items);
    return _items;
  }

  void fillRecords(List<Map<String, dynamic>> fieldData) {
    if (fieldData.isNotEmpty) {
      field.clear();
    }
    fieldData.forEach(_fillFields);
  }

  /// A map of 'field' objects
  Map<dynamic, Map<String, FieldWidgets<T>>> field = {};

  void _fillFields(Map<String, dynamic> dataFields) {
    final _fields = dataFields.values;

    // Nothing to process.
    if (_fields.isEmpty) {
      return;
    }

    // The data field's key value is the 'key' to this map!
    dynamic id = _fields.first;

    if (id is int) {
      id = id.toString();
    }

    if (field[id] == null) {
      field[id] = {};
    }

    dataFields.forEach((String key, dynamic value) {
      _fillField(id, {key: value});
    });
  }

  void _fillField(dynamic id, Map<String, dynamic> dataField) {
    //
    final name = dataField.keys.first;

    final dynamic value = dataField.values.first;

    //
    final Map<String, dynamic> map = field[id]!;

    if (map[name] == null) {
      map[name] = FieldWidgets<T>();
    }

    map[name].label = name;

    map[name].value = value;

    field[id] = map as Map<String, FieldWidgets<T>>;
  }

  // Not working yet.
  // Map<String, dynamic>? toMap([Map? fields]) {
  //   //
  //   fields ??= field;
  //
  //   final record = fields.map((key, map) {
  //     //
  //     MapEntry? record;
  //
  //     MapEntry fld;
  //
  //     for (final rec in map.entries) {
  //       //
  //       if (rec.value is FieldWidgets<T>) {
  //         fld = MapEntry(rec.key, rec.value.value);
  //       } else {
  //         fld = MapEntry(rec.key, rec.value);
  //       }
  //       record = MapEntry(key as String, fld);
  //     }
  //     return record;
  //   });
  //   return record;
  // }
}

/// The base 'Field' Widget class
class FieldWidgets<T> extends DataFieldItem with StateGetter {
  /// Constructor supplies all the options depending on the field Widget.
  FieldWidgets({
    Object? key,
    this.object,
    String? label,
    dynamic value,
    dynamic type,
// TextFormField
    this.controller,
    this.initialValue,
    this.focusNode,
    this.inputDecoration,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.textSpan,
    this.style,
    this.textAlign,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
//    this.autovalidate,
//    this.maxLengthEnforced,
    this.maxLengthEnforcement,
    this.maxLines,
    this.maxLength,
    this.changed,
    this.editingComplete,
    this.fieldSubmitted,
    this.saved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.keyboardAppearance,
    this.scrollPadding,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
// Text
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
// ListTile
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine,
    this.dense,
    this.visualDensity,
    this.shape,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.tap,
    this.longPress,
    this.mouseCursor,
    this.selected,
    this.focusColor,
    this.hoverColor,
    this.tileColor,
    this.selectedTileColor,
// CheckboxListTile
    this.secondary,
    this.controlAffinity,
// CircleAvatar
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
// Dismissible
    this.child,
    this.background,
    this.secondaryBackground,
    this.resize,
    this.dismissed,
    this.direction,
    this.resizeDuration,
    this.dismissThresholds,
    this.movementDuration,
    this.crossAxisEndOffset,
// CheckBox
    this.toggle,
    this.activeColor,
    this.tristate,
    this.materialTapTargetSize,
  }) : super(label: label, value: value, type: type) {
    _key = ObjectKey(key ?? this).toString();
    // ignore: avoid_bool_literals_in_conditional_expressions
    _checkValue = value == null
        ? false
        : value is String
            ? value.isNotEmpty
            : value is bool
                ? value
                // ignore: avoid_bool_literals_in_conditional_expressions
                : value is int
                    // ignore: avoid_bool_literals_in_conditional_expressions
                    ? value > 0
                        ? true
                        // ignore: avoid_bool_literals_in_conditional_expressions
                        : value is double
                            ? value > 0
                            : false
                    : false;

    // Record the initial value.
    if (value is! Iterable) {
      _initValue = value ?? initialValue;
    }

    // Default values
    textCapitalization ??= TextCapitalization.none;
    textInputAction ??= TextInputAction.done;
    textAlign ??= TextAlign.start;
    autofocus ??= false;
    obscureText ??= false;
    autocorrect ??= true;
//    autovalidate ??= false;
//    maxLengthEnforced ??= true;
    maxLengthEnforcement ??= MaxLengthEnforcement.enforced;
    maxLines ??= 1;
    scrollPadding ??= const EdgeInsets.all(20);

    isThreeLine ??= false;
    enabled ??= true;
    selected ??= false;

    direction ??= DismissDirection.endToStart;
    resizeDuration ??= const Duration(milliseconds: 300);
    dismissThresholds ??= const <DismissDirection, double>{};
    movementDuration ??= const Duration(milliseconds: 200);
    crossAxisEndOffset ??= 0.0;
  }

  ///
  T? object;

  dynamic _initValue;

  bool _valueChanged = false;

  ///
  Iterable<DataFieldItem>? items;

  static final ThemeData? _theme = App.themeData;

  ///
  String? get key => _key;
  String? _key;

  ///todo: TextFormField
  TextEditingController? controller;

  /// The current text being edited.
  String? initialValue;

  /// To obtain the keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  /// The border, labels, icons, and styles used to decorate a Material
  /// Design text field.
  InputDecoration? inputDecoration;

  /// The type of information for which to optimize the text input control.
  TextInputType? keyboardType;

  /// Configures how the platform keyboard will select an uppercase or
  /// lowercase keyboard.
  TextCapitalization? textCapitalization;

  /// An action the user has requested the text input control to perform.
  TextInputAction? textInputAction;

  /// Describing how to format and paint text.
  TextStyle? style;

  /// Whether and how to align text horizontally.
  TextAlign? textAlign;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  bool? autofocus;

  /// Whether to hide the text being edited (e.g., for passwords).
  bool? obscureText;

  /// Whether to enable autocorrection.
  bool? autocorrect;

//  bool autovalidate;
//  bool? maxLengthEnforced;
  /// Determines how the [maxLength] limit should be enforced.
  MaxLengthEnforcement? maxLengthEnforcement;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  int? maxLines;

  /// The maximum string length that can be entered into the TextField.
  int? maxLength;

  ///
  ValueChanged<String>? changed;

  ///
  VoidCallback? editingComplete;

  ///
  ValueChanged<String>? fieldSubmitted;

  ///
  FormFieldSetter<String>? saved;

  ///
  FormFieldValidator<String>? validator;

  /// Optional input validation and formatting overrides.
  List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// decoration is rendered in grey.
  bool? enabled;

  /// The appearance of the keyboard.
  /// This setting is only honored on iOS devices.
  Brightness? keyboardAppearance;

  ///
  EdgeInsets? scrollPadding;

  ///
  InputCounterWidgetBuilder? buildCounter;

  ///
  ScrollPhysics? scrollPhysics;

  /// A list of strings that helps the autofill service identify the type of this
  /// text input.
  Iterable<String>? autofillHints;

  /// Used to enable/disable this form field auto validation and update its
  /// error text.
  AutovalidateMode? autovalidateMode;

  ///todo: Text
//  final String data;
  TextSpan? textSpan;

  // final TextStyle style;
  // final TextAlign textAlign;
  ///
  TextDirection? textDirection;

  ///
  Locale? locale;

  /// If the [softWrap] is true or null, the glyph causing overflow, and those that follow,
  /// will not be rendered. Otherwise, it will be shown with the given overflow option.
  bool? softWrap;

  /// How visual overflow should be handled.
  TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  double? textScaleFactor;

//final int maxLines;
  /// An alternative semantics label for this text.
  String? semanticsLabel;

  /// Defines how to measure the width of the rendered text.
  TextWidthBasis? textWidthBasis;

  /// Specifies how the `height` multiplier is
  /// applied to ascent of the first line and the descent of the last line.
  ui.TextHeightBehavior? textHeightBehavior;

  ///todo: [ListTile]
  /// A widget to display before the title.
  Widget? leading;

  /// The primary content of the list tile.
  Widget? title;

  /// Additional content displayed below the title.
  Widget? subtitle;

  /// A widget to display after the title.
  Widget? trailing;

  /// Whether this list tile is intended to display three lines of text.
  bool? isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  bool? dense;

  /// Defines how compact the list tile's layout will be.
  VisualDensity? visualDensity;

  /// Defines the tile's ['InkWell.customBorder'] and [Ink.decoration] shape.
  ShapeBorder? shape;

  /// Defines the color used for icons and text when the list tile is selected.
  Color? selectedColor;

  /// Defines the default color for [leading] and [trailing] icons.
  Color? iconColor;

  /// Defines the default color for the [title] and [subtitle].
  Color? textColor;

  /// The tile's internal padding.
  EdgeInsetsGeometry? contentPadding;

//  final bool enabled;
  /// Called when the user taps this list tile.
  GestureTapCallback? tap;

  /// Called when the user long-presses on this list tile.
  GestureLongPressCallback? longPress;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  MouseCursor? mouseCursor;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  bool? selected;

  /// The color for the tile's [Material] when it has the input focus.
  Color? focusColor;

  /// The color for the tile's [Material] when a pointer is hovering over it.
  Color? hoverColor;

  /// Defines the background color of `ListTile` when [selected] is false.
  Color? tileColor;

  /// Defines the background color of `ListTile` when [selected] is true.
  Color? selectedTileColor;

  ///todo: [CheckboxListTile]
  /// A widget to display on the opposite side of the tile from the checkbox.
  Widget? secondary;

  /// Where to place the control relative to the text.
  ListTileControlAffinity? controlAffinity;

  ///todo: [CircleAvatar]
  /// The color with which to fill the circle.
  Color? backgroundColor;

  /// The default text color for text in the circle.
  Color? foregroundColor;

  /// The background image of the circle. Changing the background
  /// image will cause the avatar to animate to the new image.
  ImageProvider? backgroundImage;

  /// The foreground image of the circle.
  ImageProvider? foregroundImage;

  /// An optional error callback for errors emitted when loading
  ImageErrorListener? onBackgroundImageError;

  /// An optional error callback for errors emitted when loading
  ImageErrorListener? onForegroundImageError;

  /// The size of the avatar, expressed as the radius (half the diameter).
  double? radius;

  ///
  double? minRadius;

  ///
  double? maxRadius;

  ///todo: [Dismissible]
  Widget? child;

  ///
  Widget? background;

  ///
  Widget? secondaryBackground;

  ///
  VoidCallback? resize;

  ///
  DismissDirectionCallback? dismissed;

  ///
  DismissDirection? direction;

  ///
  Duration? resizeDuration;

  ///
  Map<DismissDirection, double>? dismissThresholds;

  ///
  Duration? movementDuration;

  ///
  double? crossAxisEndOffset;

  ///todo: ['CheckBox']
  bool? _checkValue;

  ///
  ValueChanged<bool>? toggle;

  ///
  Color? activeColor;

  ///
  bool? tristate;

  ///
  MaterialTapTargetSize? materialTapTargetSize;

  m.Widget? _textFormField;
  Dismissible? _dismissible;
  Checkbox? _checkbox;

  ///
  m.Widget get textFormField {
    // if (items == null && value != null && value is! String) {
    //   items = value;
    //   value = null;
    // }
    String text;
    if (value == null) {
      text = '';
    } else if (value is bool) {
      text = value ? 'true' : 'false';
    } else if (value is String) {
      text = value.trim();
    } else {
      text = value.toString().trim();
    }
//    return _textFormField ??= m.Material(
    return m.Material(
        child: m.TextFormField(
      key: Key('TextFormField$_key'),
      controller:
          controller ?? (value == null ? null : FieldController(text: text)),
      initialValue: controller == null && value == null ? initialValue : null,
      focusNode: focusNode,
      decoration: inputDecoration ?? InputDecoration(labelText: label),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization!,
      textInputAction: textInputAction,
      style: style,
      textAlign: textAlign!,
      autofocus: autofocus!,
      obscureText: obscureText!,
      autocorrect: autocorrect!,
//      autovalidate: autovalidate,
//      maxLengthEnforced: maxLengthEnforced!,
      maxLengthEnforcement: maxLengthEnforcement!,
      maxLines: maxLines,
      onChanged: changed ?? onChanged,
      maxLength: maxLength,
      onEditingComplete: editingComplete ?? onEditingComplete,
      onFieldSubmitted: fieldSubmitted ?? onFieldSubmitted,
      onSaved: saved ?? onSaved,
      validator: validator ?? onValidator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding!,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
    ));
  }

  ///
  m.TextFormField onTextFormField({
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? inputDecoration,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    TextAlign? textAlign,
    bool? autofocus,
    bool? obscureText,
    bool? autocorrect,
    bool? autovalidate,
//    bool? maxLengthEnforced,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? maxLength,
    VoidCallback? editingComplete,
    ValueChanged<String>? fieldSubmitted,
    FormFieldSetter<String>? saved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    bool create = false,
  }) {
    this.controller = controller ?? this.controller;
    this.initialValue = initialValue ?? this.initialValue;
    this.focusNode = focusNode ?? this.focusNode;
    this.inputDecoration = inputDecoration ?? this.inputDecoration;
    this.keyboardType = keyboardType ?? this.keyboardType;
    this.textCapitalization = textCapitalization ?? this.textCapitalization;
    this.textInputAction = textInputAction ?? this.textInputAction;
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.autofocus = autofocus ?? this.autofocus;
    this.obscureText = obscureText ?? this.obscureText;
    this.autocorrect = autocorrect ?? this.autocorrect;
//    this.autovalidate = autovalidate ?? this.autovalidate;
//    this.maxLengthEnforced = maxLengthEnforced ?? this.maxLengthEnforced;
    this.maxLengthEnforcement =
        maxLengthEnforcement ?? this.maxLengthEnforcement;
    this.maxLines = maxLines ?? this.maxLines;
    this.maxLength = maxLength ?? this.maxLength;
    this.editingComplete = editingComplete ?? this.editingComplete;
    this.fieldSubmitted = fieldSubmitted ?? this.fieldSubmitted;
    this.saved = saved ?? this.saved;
    this.validator = validator ?? this.validator;
    this.inputFormatters = inputFormatters ?? this.inputFormatters;
    this.enabled = enabled ?? this.enabled;
    this.keyboardAppearance = keyboardAppearance ?? this.keyboardAppearance;
    this.scrollPadding = scrollPadding ?? this.scrollPadding;
    this.buildCounter = buildCounter ?? this.buildCounter;
    this.scrollPhysics = scrollPhysics ?? this.scrollPhysics;
    this.autofillHints = autofillHints ?? this.autofillHints;
    this.autovalidateMode = autovalidateMode ?? this.autovalidateMode;

    final oldWidget = _textFormField;
    _textFormField = null;
    final newWidget = textFormField;
    _textFormField = oldWidget;
    return newWidget as m.TextFormField;
  }

  ///
  // ignore: non_constant_identifier_names
  m.Widget TextFormField({
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? inputDecoration,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    TextAlign? textAlign,
    bool? autofocus,
    bool? obscureText,
    bool? autocorrect,
    bool? autovalidate,
//    bool? maxLengthEnforced,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? maxLength,
    ValueChanged<String>? changed,
    VoidCallback? editingComplete,
    ValueChanged<String>? fieldSubmitted,
    FormFieldSetter<String>? saved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
  }) =>
      m.Material(
        child: m.TextFormField(
          key: Key('TextFormField$_key'),
          // just accept the parameter values and not this object's values.
          controller: controller ??
              (initialValue == null
                  ? null
                  : FieldController(text: initialValue)),
          // ignore the initValue parameter: initialValue: null,
          focusNode: focusNode ?? focusNode,
          decoration: inputDecoration ?? this.inputDecoration,
          keyboardType: keyboardType ?? this.keyboardType,
          textCapitalization: textCapitalization ?? this.textCapitalization!,
          textInputAction: textInputAction ?? this.textInputAction,
          style: style ?? this.style,
          textAlign: textAlign ?? this.textAlign!,
          autofocus: autofocus ?? this.autofocus!,
          obscureText: obscureText ?? this.obscureText!,
          autocorrect: autocorrect ?? this.autocorrect!,
//        autovalidate: autovalidate ?? this.autovalidate,
//          maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced!,
          maxLengthEnforcement:
              maxLengthEnforcement ?? this.maxLengthEnforcement!,
          maxLines: maxLines ?? this.maxLines,
          maxLength: maxLength ?? this.maxLength,
          onChanged: changed ?? this.changed ?? onChanged,
          onEditingComplete:
              editingComplete ?? this.editingComplete ?? onEditingComplete,
          onFieldSubmitted:
              fieldSubmitted ?? this.fieldSubmitted ?? onFieldSubmitted,
          onSaved: saved ?? this.saved ?? onSaved,
          validator: validator ?? this.validator ?? onValidator,
          inputFormatters: inputFormatters ?? this.inputFormatters,
          enabled: enabled ?? this.enabled,
          keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
          scrollPadding: scrollPadding ?? this.scrollPadding!,
          buildCounter: buildCounter ?? this.buildCounter,
          scrollPhysics: scrollPhysics ?? this.scrollPhysics,
          autofillHints: autofillHints ?? this.autofillHints,
          autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        ),
      );

  /// Override to perform what happens when finished editing the field.
  void onEditingComplete() {}

  /// Override to perform what happens when the field value is submitted.
  void onFieldSubmitted(String v) {}

  /// What happens when the field is saved?
  @mustCallSuper
  void onSaved(dynamic v) {
    if (isChanged()) {
      value = v;
    }
  }

  /// Override to return a different field value when validating.
  /// Return null if validated. Error message if not.
  @mustCallSuper
  @protected
  String? onValidator(String? v) {
    const String? valid = null;
    return valid;
  }

  ///
  Text get text {
    // if (items == null && value != null && value is! String) {
    //   items = value;
    //   value = null;
    // }
    String text;
    if (value == null) {
      text = '';
    } else if (value is bool) {
      text = value ? 'true' : 'false';
    } else if (value is String) {
      text = value.trim();
    } else {
      text = value.toString().trim();
    }
    return Text(
      text,
      key: Key('Text$_key'),
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  ///
  Text onText({
    TextSpan? textSpan,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
  }) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.textDirection = textDirection ?? this.textDirection;
    this.locale = locale ?? this.locale;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.textScaleFactor = textScaleFactor ?? this.textScaleFactor;
    this.maxLines = maxLines ?? this.maxLines;
    this.semanticsLabel = semanticsLabel ?? this.semanticsLabel;
    this.textWidthBasis = textWidthBasis ?? this.textWidthBasis;
    this.textHeightBehavior = textHeightBehavior ?? this.textHeightBehavior;
    Text newWidget;
    // text getter
    if (textSpan == null) {
      newWidget = text;
    } else {
      this.textSpan = textSpan;
      // richText getter
      newWidget = richText;
    }
    return newWidget;
  }

  ///
  Text get richText {
    if (textSpan == null) {
      return text;
    } else {
      return Text.rich(
        textSpan!,
        key: Key('Text.rich$_key'),
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      );
    }
  }

  ///
  Text onRichText({
    TextSpan? textSpan,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
  }) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.textDirection = textDirection ?? this.textDirection;
    this.locale = locale ?? this.locale;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.textScaleFactor = textScaleFactor ?? this.textScaleFactor;
    this.maxLines = maxLines ?? this.maxLines;
    this.semanticsLabel = semanticsLabel ?? this.semanticsLabel;
    this.textWidthBasis = textWidthBasis ?? this.textWidthBasis;
    this.textHeightBehavior = textHeightBehavior ?? this.textHeightBehavior;
    Text newWidget;
    // text getter
    if (textSpan == null) {
      newWidget = text;
    } else {
      this.textSpan = textSpan;
      // richText getter
      newWidget = richText;
    }
    return newWidget;
  }

  ///
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle(
        key: Key('DefaultTextStyle$_key'),
        style: style!,
        textAlign: textAlign,
        softWrap: softWrap!,
        overflow: overflow!,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis!,
        textHeightBehavior: textHeightBehavior,
        child: child ?? text,
      );

  ///
  DefaultTextStyle onDefaultTextStyle({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    Widget? child,
  }) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.maxLines = maxLines ?? this.maxLines;
    this.textWidthBasis = textWidthBasis ?? this.textWidthBasis;
    this.textHeightBehavior = textHeightBehavior ?? this.textHeightBehavior;
    this.child = child ?? this.child;
    return defaultTextStyle;
  }

  ///
  Widget get listTile => App.useCupertino
      ? CupertinoListTile(
          key: Key('ListTile$_key'),
          leading: leading ?? onLeading(),
          title: title ?? onTitle(),
          subtitle: subtitle ?? onSubtitle(),
          trailing: trailing,
        )
      : ListTile(
          key: Key('ListTile$_key'),
          leading: leading ?? onLeading(),
          title: title ?? onTitle(),
          subtitle: subtitle ?? onSubtitle(),
          trailing: trailing,
          isThreeLine: isThreeLine ?? false,
          dense: dense,
          iconColor: iconColor,
          textColor: textColor,
          visualDensity: visualDensity,
          shape: shape,
          selectedColor: selectedColor,
          contentPadding: contentPadding,
          enabled: enabled ?? true,
          onTap: tap ?? onTap,
          onLongPress: longPress ?? onLongPress,
          selected: selected ?? false,
          focusColor: focusColor,
          hoverColor: hoverColor,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          tileColor: tileColor,
          selectedTileColor: selectedTileColor,
        );

  ///
  Widget onListTile({
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    bool? isThreeLine,
    bool? dense,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Color? selectedColor,
    Color? iconColor,
    Color? textColor,
    EdgeInsetsGeometry? contentPadding,
    bool? enabled,
    GestureTapCallback? tap,
    GestureLongPressCallback? longPress,
    bool? selected,
  }) {
    this.leading = leading ?? this.leading;
    this.title = title ?? this.title;
    this.subtitle = subtitle ?? this.subtitle;
    this.trailing = trailing ?? this.trailing;
    this.isThreeLine = isThreeLine ?? this.isThreeLine;
    this.dense = dense ?? this.dense;
    this.iconColor = iconColor ?? this.iconColor;
    this.textColor = textColor ?? this.textColor;
    this.visualDensity = visualDensity ?? this.visualDensity;
    this.shape = shape ?? this.shape;
    this.selectedColor = selectedColor ?? this.selectedColor;
    this.contentPadding = contentPadding ?? this.contentPadding;
    this.enabled = enabled ?? this.enabled;
    this.tap = tap ?? this.tap;
    this.longPress = longPress ?? this.longPress;
    this.selected = selected ?? this.selected;
    return listTile;
  }

  //for LisTile
  ///
  Widget? onLeading() => null;

  ///
  Widget onTitle() => text;

  /// Override to produce a subtitle.
  Widget onSubtitle() => Text(label!);

  ///
  Widget? onTrailing() => null;

  /// Override to place what happens when the field is tapped.
  void onTap() {}

  /// Override to place what happens when the field is 'long' pressed.
  void onLongPress() {}

  ///
  CheckboxListTile get checkboxListTile => CheckboxListTile(
        key: Key('CheckboxListTile$_key'),
        value: _checkValue,
        onChanged: toggle as void Function(bool?)? ??
            onToggle as void Function(bool?)?,
        activeColor: activeColor,
        title: title ?? onTitle(),
        subtitle: subtitle ?? onSubtitle(),
        isThreeLine: isThreeLine ?? false,
        dense: dense,
        secondary: secondary ?? onSecondary(),
        selected: selected ?? false,
        controlAffinity: controlAffinity!,
      );

  ///
  CheckboxListTile onCheckboxListTile({
    bool? value,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
    Widget? title,
    Widget? subtitle,
    bool? isThreeLine,
    bool? dense,
    Widget? secondary,
    bool? selected,
    ListTileControlAffinity? controlAffinity,
  }) {
    _checkValue = value ?? _checkValue;
    toggle = onChanged ?? toggle;
    this.activeColor = activeColor ?? this.activeColor;
    this.title = title ?? this.title;
    this.subtitle = subtitle ?? this.subtitle;
    this.isThreeLine = isThreeLine ?? this.isThreeLine;
    this.dense = dense ?? this.dense;
    this.secondary = secondary ?? this.secondary;
    this.selected = selected ?? this.selected;
    this.controlAffinity = controlAffinity ?? this.controlAffinity;
    return checkboxListTile;
  }

  /// A widget to display on the opposite side of the tile from the checkbox.
  Widget? onSecondary() => null;

  ///
  CircleAvatar get circleAvatar => CircleAvatar(
        key: Key('CircleAvatar$_key'),
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        foregroundColor: foregroundColor,
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
        child: Text(initials(value)),
      );

  ///
  CircleAvatar onCircleAvatar({
    Color? backgroundColor,
    Color? foregroundColor,
    ImageProvider? backgroundImage,
    double? radius,
    double? minRadius,
    double? maxRadius,
  }) {
    this.backgroundColor = backgroundColor ?? this.backgroundColor;
    this.backgroundImage = backgroundImage ?? this.backgroundImage;
    this.foregroundColor = foregroundColor ?? this.foregroundColor;
    this.radius = radius ?? this.radius;
    this.minRadius = minRadius ?? this.minRadius;
    this.maxRadius = maxRadius ?? this.maxRadius;
    return circleAvatar;
  }

  ///
  Dismissible get dismissible => _dismissible ??= Dismissible(
        key: Key('Dismissible$_key'),
        background: background ?? onBackground(),
        secondaryBackground: secondaryBackground ?? onSecondaryBackground(),
        onResize: resize ?? onResize,
        onDismissed: (DismissDirection direction) =>
            dismissed == null ? onDismissed(direction) : dismissed!(direction),
        direction: direction!,
        resizeDuration: resizeDuration,
        dismissThresholds: dismissThresholds!,
        movementDuration: movementDuration!,
        crossAxisEndOffset: crossAxisEndOffset!,
        child: child ?? onChild(),
      );

  ///
  Dismissible onDismissible({
    Widget? child,
    Widget? background,
    Widget? secondaryBackground,
    VoidCallback? resize,
    DismissDirectionCallback? dismissed,
    DismissDirection? direction,
    Duration? resizeDuration,
    Map<DismissDirection, double>? dismissThresholds,
    Duration? movementDuration,
    double? crossAxisEndOffset,
  }) {
    this.child = child ?? this.child;
    this.background = background ?? this.background;
    this.secondaryBackground = secondaryBackground ?? this.secondaryBackground;
    this.resize = resize ?? this.resize;
    this.dismissed = dismissed ?? this.dismissed;
    this.direction = direction ?? this.direction;
    this.resizeDuration = resizeDuration ?? this.resizeDuration;
    this.dismissThresholds = dismissThresholds ?? this.dismissThresholds;
    this.movementDuration = movementDuration ?? this.movementDuration;
    this.crossAxisEndOffset = crossAxisEndOffset ?? this.crossAxisEndOffset;
    return dismissible;
  }

  /// Override to place a different child in the Dismissible.
  Widget onChild() {
    return Container(
        decoration: BoxDecoration(
            color: _theme!.canvasColor,
            border: Border(bottom: BorderSide(color: _theme!.dividerColor))),
        child: listTile);
  }

  // for Dismissible
  ///
  Widget onBackground() {
    return Container(
      color: Colors.red,
      child: const m.Material(
        child: ListTile(
          trailing: Icon(
            Icons.delete,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }

  /// Override to provide a secondary background.
  Widget? onSecondaryBackground() => null;

  /// Override to place what happens when the field is resized.
  void onResize() {}

  /// Override to place here what happens when the field is dismissed.
  void onDismissed(DismissDirection direction) {}

  ///
  Checkbox get checkbox => _checkbox ??= Checkbox(
        key: Key('Checkbox$_key'),
        value: _checkValue,
        tristate: tristate!,
        onChanged: toggle as void Function(bool?)? ??
            onToggle as void Function(bool?)?,
        activeColor: activeColor,
        materialTapTargetSize: materialTapTargetSize,
      );

  ///
  Checkbox onCheckBox({
    bool? value,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
    bool? tristate,
    MaterialTapTargetSize? materialTapTargetSize,
  }) {
    _checkValue = value ?? _checkValue;
    toggle = onChanged ?? toggle;
    this.activeColor = activeColor ?? this.activeColor;
    this.tristate = tristate ?? this.tristate;
    this.materialTapTargetSize =
        materialTapTargetSize ?? this.materialTapTargetSize;
    final oldWidget = _checkbox;
    _checkbox = null;
    final newWidget = checkbox;
    _checkbox = oldWidget;
    return newWidget;
  }

  @mustCallSuper
  @protected

  ///
  void onChanged(String? value) {
    if (_initValue == null) {
      _valueChanged = value != null;
    } else {
      _valueChanged = _initValue != value;
    }
  }

  @protected

  ///
  bool isChanged({bool? changed}) {
    // Only record a change
    if (changed != null && changed) {
      _valueChanged = changed;
    }
    return _valueChanged;
  }

  ///
  void onToggle({bool? value}) {}

  ///
  ListItems<T> get listItems => ListItems<T>(
        this,
        title: label,
        items: items as List<DataFieldItem>? ?? [this],
        dropItems: onDropItems() ?? [''],
      );

  ///
  ListItems<T> onListItems({
    String? title,
    List<FieldWidgets<T>>? items,
    MapItemFunction? mapItem,
    GestureTapCallback? onTap,
    ValueChanged<String?>? onChanged,
    List<String>? dropItems,
  }) {
    return ListItems<T>(
      this,
      title: title ?? label,
      items: items ?? this.items as List<DataFieldItem>?,
      mapItem: mapItem,
      onTap: onTap,
      onChanged: onChanged,
      dropItems: dropItems ?? onDropItems() ?? [''],
    );
  }

  /// Allow a subclass supply the drop items.
  List<String>? onDropItems() => [''];

  /// Convert a list item into separate objects.
  void one2Many<U extends FieldWidgets<T>>(
    U Function() create,
  ) {
    if (value is! List<DataFieldItem>) {
      return;
    }
    final List<DataFieldItem> dataItems = value;
    value = null;

    final fields = <U>[];

    for (final item in dataItems) {
      final field = create()
        ..value = item.value
        ..initialValue = item.value
        ..type = item.type
        ..label = item.label
        ..id = item.id;

      fields.add(field);
    }
    items = fields;
  }

  ///
  List<Map<String, dynamic>> mapItems<U extends FieldWidgets<T>>(String key,
      List<DataFieldItem>? items, U Function(DataFieldItem dataItem) create,
      [U? itemsObj]) {
    //
    items = [];

    itemsObj ??= this as U?;

    itemsObj!.items ??= <U>[];

    // A new value must be added to the 'items' iterable.
    if (itemsObj.value is String) {
      final String value = itemsObj.value;
      if (value.isNotEmpty) {
        final newItem = create(DataFieldItem(
          label: itemsObj.label,
          value: itemsObj.value,
          type: itemsObj.type,
        ));
        itemsObj.items = itemsObj.items!.toList()..add(newItem);
      }
      // Clear them just to be safe.
      itemsObj.value = '';
      itemsObj.type = '';
    }

    final list = <Map<String, dynamic>>[];

    //ignore: unnecessary_cast
    for (final item in (itemsObj.items ?? []) as Iterable) {
      // Assign the appropriate map key value.
      item.keys(value: key);
      list.add(item.toMap);
    }

    return list;
  }

  ///
  String initials(String fullName) {
    //
    final names = fullName.split(' ');

    final initials = StringBuffer();

    for (final name in names) {
      if (name.isEmpty) {
        continue;
      }
      initials.write(name[0]);
    }
    return initials.toString().toUpperCase();
  }
}

/// Cupertino needs a ListTile equivalent
/// https://github.com/flutter/flutter/issues/50668
class CupertinoListTile extends StatefulWidget {
  ///
  const CupertinoListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  ///
  final Widget? leading;

  ///
  final Widget? title;

  ///
  final Widget? subtitle;

  ///
  final Widget? trailing;

  ///
  final Function? onTap;
  @override
  _StatefulStateCupertino createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    late Widget leading;
    if (widget.leading == null) {
      leading = const SizedBox();
    } else {
      leading = widget.leading!;
    }
    Widget trailing;
    if (widget.trailing == null) {
      trailing = const SizedBox();
    } else {
      trailing = widget.trailing!;
    }
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: leading),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren(context),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: trailing),
        ],
      ),
    );
  }

  List<Widget> columnChildren(BuildContext context) {
    final children = <Widget>[];
    children.add(widget.title ?? const SizedBox());
    if (widget.subtitle != null) {
      children.add(widget.subtitle!);
    }
    return children;
  }
}

/// Item class used for fields
class DataFieldItem {
  /// Supply a identifier, a [label], a [value] and a maybe a [type] of value.
  DataFieldItem({
    this.id,
    this.label,
    this.value,
    this.type,
  });

  /// Crate a Field Item object from a Map
  /// supplying a identifier, a [label], a [value] and a maybe a [type] of value.
  DataFieldItem.fromMap(
    Map<dynamic, dynamic> m, {
    String? id,
    String? label,
    String? value,
    String? type,
  }) {
    //
    keys(id: id, label: label, value: value, type: type);

    this.id = m[_id];
    this.label = m[_label];
    this.value = m[_value];
    this.type = m[_type];
  }

  ///
  dynamic id;

  ///
  String? label;

  ///
  dynamic value;

  ///
  dynamic type;

  String _id = 'id';
  String _label = 'label';
  String _value = 'value';
  String _type = 'type';

  /// Assigns the names for the 'label' field and the 'value' field.
  void keys({String? id, String? label, String? value, String? type}) {
    if (id != null && id.isNotEmpty) {
      _id = id;
    }
    if (label != null && label.isNotEmpty) {
      _label = label;
    }
    if (value != null && value.isNotEmpty) {
      _value = value;
    }
    if (type != null && type.isNotEmpty) {
      _type = type;
    }
  }

  // Fix Error: type '_InternalLinkedHashMap<dynamic, dynamic>' is not a subtype of type 'Map<String, String>'
  ///
  Map<String, dynamic> get toMap =>
      {_id: id, _label: label, _value: value, _type: type};
}

/// Supplies the 'current' State object.
mixin StateGetter {
  bool _init = false;
  StateMVC? _state;
  final Set<StateMVC> _stateSet = {};

  /// The 'current' State object.
  StateMVC? get state => _state;

  /// Call this in the State object's initState() function.
  void initState(StateMVC? state) => pushState(state);

  /// Add the optional State object to the Set
  bool pushState([StateMVC? state]) {
    if (state == null) {
      return false;
    }
    _init = true;
    _state = state;
    return _stateSet.add(state);
  }

  /// Call this in the State object's dispose function.
  bool dispose() => popState();

  /// Pop out the last State object from the Set.
  bool popState() {
    // Don't continue if not initiated.
    if (!_init) {
      return true;
    }
    // Don't continue if null.
    if (_state == null) {
      return true;
    }
    // Remove the 'current' state
    final removed = _stateSet.remove(_state);
    // Reassign the last state object.
    if (_stateSet.isEmpty) {
      _state = null;
    } else {
      _state = _stateSet.last;
    }
    return removed;
  }

  /// Notify the framework of a rebuild in the next scheduled frame
  bool setState(VoidCallback fn) {
    final set = _state != null;
    if (set) {
      // ignore: invalid_use_of_protected_member
      _state!.setState(fn);
    }
    return set;
  }

  /// Notify the framework of a rebuild in the next scheduled frame
  bool refresh() => setState(() {});

  /// Notify the framework of a rebuild in the next scheduled frame
  bool rebuild() => refresh();
}

///
class ListItems<T> extends StatefulWidget {
  ///
  const ListItems(
    this.field, {
    Key? key,
    this.title,
    this.items,
    this.mapItem,
    this.onTap,
    this.onChanged,
    this.dropItems,
  }) : super(key: key);

  ///
  final FieldWidgets<T> field;

  ///
  final String? title;

  ///
  final List<DataFieldItem>? items;

  ///
  final MapItemFunction? mapItem;

  ///
  final GestureTapCallback? onTap;

  ///
  final ValueChanged<String?>? onChanged;

  ///
  final List<String>? dropItems;
  @override
  State createState() => _LIstItemsState<T>();
}

class _LIstItemsState<T> extends State<ListItems<T>> {
  FormState? formState;
  MapItemFunction? _map;
  List<DataFieldItem>? items;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    if (widget.mapItem == null) {
      if (widget.onTap == null) {
        _map = editIt as Widget Function(DataFieldItem)?;
      } else {
        _map = mapIt;
      }
    } else {
      _map = widget.mapItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    if (widget.onTap == null) {
      children = [
        Row(children: [
          dropDown(
            field: widget.field,
            onChanged: widget.onChanged,
          ),
          Expanded(child: widget.field.textFormField),
        ])
      ];
    } else {
      m.Widget tile;
      if (App.useMaterial) {
        tile = ListTile(
          subtitle: Text(widget.title!),
          onTap: widget.onTap,
        );
      } else {
        tile = CupertinoListTile(
          subtitle: Text(widget.title!),
          onTap: widget.onTap,
        );
      }
      children = [
        tile,
      ];
    }
    if (items != null) {
      children.add(Column(
          children: widget.items!
              .map((i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _map!(i)))
              .toList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget mapIt(DataFieldItem i) => App.useMaterial
      ? ListTile(
          title: Text(i.value ?? ''),
          subtitle: Text(i.type ?? ''),
          onTap: widget.onTap,
        )
      : CupertinoListTile(
          title: Text(i.value ?? ''),
          subtitle: Text(i.type ?? ''),
          onTap: widget.onTap,
        );

  Widget editIt(FieldWidgets<T> i) => App.useMaterial
      ? ListTile(
          title: Row(children: [
            dropDown(
              field: i,
              onChanged: widget.onChanged,
            ),
            Expanded(
                child: i.TextFormField(
              inputDecoration: const InputDecoration(labelText: ''),
              initialValue: i.value,
              changed: i.onChanged,
            )),
          ]),
          onTap: widget.onTap,
        )
      : CupertinoListTile(
          title: Row(children: [
            dropDown(
              field: i,
              onChanged: widget.onChanged,
            ),
//            Expanded(child:
            Container(
              width: 200, // do it in both Container
              child: i.TextFormField(
                inputDecoration: const InputDecoration(labelText: ''),
                initialValue: i.value,
                changed: i.onChanged,
              ),
            ),
          ]),
          onTap: widget.onTap,
        );

  Widget dropDown({FieldWidgets<T>? field, ValueChanged<String?>? onChanged}) {
    final dropItems = widget.dropItems ?? [''];
    String? value = field?.type;
    if (dropItems.where((String item) {
      return item == value;
    }).isEmpty) {
      value = dropItems[0];
    }
    field?.type = value;
    return Material(
      child: DropdownButton<String>(
        hint: const Text('type...'),
        value: value,
        items: dropItems.map((String v) {
          return DropdownMenuItem<String>(value: v, child: Text(v));
        }).toList(),
        onChanged: (String? v) {
          field!.type = v;
          field.onChanged(v);
          if (onChanged != null) {
            onChanged(v);
          }
        },
      ),
    );
  }
}

///
typedef MapItemFunction = Widget Function(DataFieldItem i);

/// Overcome ListView bug.
class FieldController extends TextEditingController {
  /// Supply the initial Text field value.
  FieldController({String? text}) : super(text: text);
}

/// Used to test for a Map object before attempting to access it.
class MapClass {
  ///
  MapClass(this.map);

  ///
  final Map<String, dynamic>? map;

  ///
  dynamic p(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }
    if (map == null) {
      return null;
    }
    return map![key];
  }
}
