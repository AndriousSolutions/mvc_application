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

import 'package:flutter/services.dart'
    show
        Brightness,
        TextCapitalization,
        TextInputAction,
        TextInputFormatter,
        TextInputType;

import 'package:mvc_application/view.dart';

typedef OnSavedFunc = Function<E>(E v);

class DataFields extends _AddFields {
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

  FormState _formState;

  Widget linkForm(child) => _ChildForm(parent: this, child: child);

  bool saveForm() {
    bool save = _formState?.validate() ?? true;
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
  String get errorText => _errorText;
  String _errorText = " ";

  /// True if this field has any validation errors.
  bool get hasError => _errorText != null;

  /// Any errors from every [FormField] that is a descendant of this [Form].
  String fieldErrors() {
    String errors = "";
    for (final FormFieldState<dynamic> field in _fields)
      if (field.hasError) errors = errors + field.errorText;
    return errors;
  }
}

abstract class _AddFields extends _EditFields {
  Future<bool> add(Map<String, dynamic> rec);
}

abstract class _EditFields extends _ListFields {
  /// The save record routine.
  Future<bool> save(Map<String, dynamic> rec);

  Future<bool> delete(Map<String, dynamic> rec);

  Future<bool> undo(Map<String, dynamic> rec);
}

abstract class _ListFields {
  /// Retrieve the data fields from the data source into a List of Maps.
  Future<List<Map<String, dynamic>>> retrieve();

  /// List of the actual data fields.
  List<Map<String, dynamic>> get items => _items;
  List<Map<String, dynamic>> _items = [{}];

  /// Retrieve the to-do items from the database
  Future<List<Map<String, dynamic>>> query() async {
    _items = await retrieve();
    _fillRecords(_items);
    return _items;
  }

  void _fillRecords(List<Map<String, dynamic>> fieldData) {
    if (fieldData.isNotEmpty) {
      this.field.clear();
    }
    for (Map<String, dynamic> field in fieldData) {
      _fillFields(field);
    }
  }

  /// A map of 'field' objects
  Map<dynamic, Map<String, FieldWidgets>> field = Map();

  void _fillFields(Map<String, dynamic> dataFields) {
    //
    dynamic id = dataFields.values.first;

    if (this.field[id] == null) {
      this.field[id] = {};
    }

    dataFields.forEach((String key, dynamic value) {
      _fillField(id, {key: value});
    });
  }

  void _fillField(dynamic id, Map<String, dynamic> dataField) {
    //
    String name = dataField.keys.first;

    dynamic value = dataField.values.first;

    //
    Map<String, dynamic> map = this.field[id];

    if (map[name] == null) {
      map[name] = FieldWidgets();
    }

    map[name].label = name;

    map[name].value = value;

    this.field[id] = map;
  }
}

class FieldWidgets<T> extends DataFieldItem {
  FieldWidgets({
    Object key,
    this.object,
    String label,
    dynamic value,
// TextFormField
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.textSpan,
    this.style,
    this.textAlign,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.autovalidate,
    this.maxLengthEnforced,
    this.maxLines,
    this.maxLength,
    this.editingComplete,
    this.fieldSubmitted,
    this.saved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.keyboardAppearance,
    this.scrollPadding,
// Text
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.semanticsLabel,
// ListTile
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine,
    this.dense,
    this.contentPadding,
    this.tap,
    this.longPress,
    this.selected,
// CheckboxListTile
    this.secondary,
    this.controlAffinity,
// CircleAvatar
    this.backgroundColor,
    this.backgroundImage,
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
    this.changed,
    this.activeColor,
    this.tristate,
    this.materialTapTargetSize,
  }) : super(label: label, value: value) {
    _key = ObjectKey(key ?? this).toString();
    _checkValue = (value == null
        ? false
        : value is String
            ? value.isNotEmpty
            : value is bool
                ? value
                : value is int
                    ? value > 0
                        ? true
                        : value is double ? value > 0 ? true : false : false
                    : false);
  }
  final T object;
  Iterable<DataFieldItem> items;

  final ThemeData _theme = App.themeData;

  String get key => _key;
  String _key;

  /// TextFormField
  TextEditingController controller;
  String initialValue;
  FocusNode focusNode;
  InputDecoration decoration;
  TextInputType keyboardType;
  TextCapitalization textCapitalization;
  TextInputAction textInputAction;
  TextStyle style;
  TextAlign textAlign;
  bool autofocus;
  bool obscureText;
  bool autocorrect;
  bool autovalidate;
  bool maxLengthEnforced;
  int maxLines;
  int maxLength;
  VoidCallback editingComplete;
  ValueChanged<String> fieldSubmitted;
  FormFieldSetter<String> saved;
  FormFieldValidator<String> validator;
  List<TextInputFormatter> inputFormatters;
  bool enabled;
  Brightness keyboardAppearance;
  EdgeInsets scrollPadding;

  /// Text
//  final String data;
  TextSpan textSpan;
  // final TextStyle style;
  // final TextAlign textAlign;
  TextDirection textDirection;
  Locale locale;
  bool softWrap;
  TextOverflow overflow;
  double textScaleFactor;
//final int maxLines;
  String semanticsLabel;

  /// ListTile
  Widget leading;
  Widget title;
  Widget subtitle;
  Widget trailing;
  bool isThreeLine;
  bool dense;
  EdgeInsetsGeometry contentPadding;
//  final bool enabled;
  GestureTapCallback tap;
  GestureLongPressCallback longPress;
  bool selected;

  /// CheckboxListTile
  Widget secondary;
  ListTileControlAffinity controlAffinity;

  /// CircleAvatar
  Color backgroundColor;
  Color foregroundColor;
  ImageProvider backgroundImage;
  double radius;
  double minRadius;
  double maxRadius;

  /// Dismissible
  Widget child;
  Widget background;
  Widget secondaryBackground;
  VoidCallback resize;
  DismissDirectionCallback dismissed;
  DismissDirection direction;
  Duration resizeDuration;
  Map<DismissDirection, double> dismissThresholds;
  Duration movementDuration;
  double crossAxisEndOffset;

  /// CheckBox
  bool _checkValue;
  ValueChanged<bool> changed;
  Color activeColor;
  bool tristate;
  MaterialTapTargetSize materialTapTargetSize;

  TextFormField _textFormField;
  Text _text;
  Text _richText;
  DefaultTextStyle _defaultTextStyle;
  ListTile _listTile;
  CheckboxListTile _checkboxListTile;
  CircleAvatar _circleAvatar;
  Dismissible _dismissible;
  Checkbox _checkbox;

  TextFormField get textFormField {
    if (_textFormField == null)
      _textFormField = TextFormField(
        key: Key('TextFormField' + _key),
        controller: controller,
        initialValue: initialValue ?? value,
        focusNode: focusNode,
        decoration: decoration ?? InputDecoration(labelText: label),
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        textInputAction: textInputAction ?? TextInputAction.done,
        style: style,
        textAlign: textAlign ?? TextAlign.start,
        autofocus: autofocus ?? false,
        obscureText: obscureText ?? false,
        autocorrect: autocorrect ?? true,
        autovalidate: autovalidate ?? false,
        maxLengthEnforced: maxLengthEnforced ?? true,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        onEditingComplete: editingComplete ?? onEditingComplete,
        onFieldSubmitted: (String v) =>
            fieldSubmitted == null ? onFieldSubmitted(v) : fieldSubmitted(v),
        onSaved: (String v) {
          if (saved == null) {
            onSaved(v);
          } else {
            saved(v);
          }
        },
        validator: (String v) =>
            validator == null ? onValidator(v) : validator(v),
        inputFormatters: inputFormatters,
        enabled: enabled,
        keyboardAppearance: keyboardAppearance,
        scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
      );
    return _textFormField;
  }

  TextFormField onTextFormField({
    TextEditingController controller,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration,
    TextInputType keyboardType,
    TextCapitalization textCapitalization,
    TextInputAction textInputAction,
    TextStyle style,
    TextAlign textAlign,
    bool autofocus,
    bool obscureText,
    bool autocorrect,
    bool autovalidate,
    bool maxLengthEnforced,
    int maxLines,
    int maxLength,
    VoidCallback editingComplete,
    ValueChanged<String> fieldSubmitted,
    FormFieldSetter<String> saved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding,
  }) {
    this.controller = controller ?? this.controller;
    this.initialValue = initialValue ?? value;
    this.focusNode = focusNode ?? this.focusNode;
    this.decoration = decoration ?? this.decoration;
    this.keyboardType = keyboardType ?? this.keyboardType;
    this.textCapitalization = textCapitalization ?? this.textCapitalization;
    this.textInputAction = textInputAction ?? this.textInputAction;
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.autofocus = autofocus ?? this.autofocus;
    this.obscureText = obscureText ?? this.obscureText;
    this.autocorrect = autocorrect ?? this.autocorrect;
    this.autovalidate = autovalidate ?? this.autovalidate;
    this.maxLengthEnforced = maxLengthEnforced ?? this.maxLengthEnforced;
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
    TextFormField oldWidget = _textFormField;
    _textFormField = null;
    TextFormField newWidget = textFormField;
    _textFormField = oldWidget;
    return newWidget;
  }

  // Override to perform what happens when finished editing the field.
  void onEditingComplete() {}

  // Override to perform what happens when the field value is submitted.
  void onFieldSubmitted(String v) {}

  // What happens when the field is saved?
  void onSaved(dynamic v) {
    value = v; // As an example  => object?.jobTitle = value = v;
  }

  // Override to return a different field value when validating.
  // Return null if validated. Error message if not.
  String onValidator(String v) => null;

  Text get text {
    if (_text == null)
      _text = Text(
        value ?? "",
        key: Key('Text' + _key),
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    return _text;
  }

  Text onText(
    TextSpan textSpan,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
  ) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.textDirection = textDirection ?? this.textDirection;
    this.locale = locale ?? this.locale;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.textScaleFactor = textScaleFactor ?? this.textScaleFactor;
    this.maxLines = maxLines ?? this.maxLines;
    this.semanticsLabel = semanticsLabel ?? this.semanticsLabel;
    Text oldWidget = _text;
    _text = null;
    Text newWidget;
    // text getter
    if (textSpan == null) {
      newWidget = text;
    } else {
      this.textSpan = textSpan;
      // richText getter
      newWidget = richText;
    }
    _text = oldWidget;
    return newWidget;
  }

  Text get richText {
    if (textSpan == null) {
      return text;
    } else {
      if (_richText == null)
        _richText = Text.rich(
          textSpan,
          key: Key('Text.rich' + _key),
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        );
      return _richText;
    }
  }

  Text onRichText(
    TextSpan textSpan,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
  ) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.textDirection = textDirection ?? this.textDirection;
    this.locale = locale ?? this.locale;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.textScaleFactor = textScaleFactor ?? this.textScaleFactor;
    this.maxLines = maxLines ?? this.maxLines;
    this.semanticsLabel = semanticsLabel ?? this.semanticsLabel;
    Text oldWidget = _richText;
    _richText = null;
    Text newWidget;
    // text getter
    if (textSpan == null) {
      newWidget = text;
    } else {
      this.textSpan = textSpan;
      // richText getter
      newWidget = richText;
    }
    _richText = oldWidget;
    return newWidget;
  }

  DefaultTextStyle get defaultTextStyle {
    if (_defaultTextStyle == null)
      _defaultTextStyle = DefaultTextStyle(
        key: Key('DefaultTextStyle' + _key),
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        child: text,
      );
    return _defaultTextStyle;
  }

  DefaultTextStyle onDefaultTextStyle(
    TextStyle style,
    TextAlign textAlign,
    bool softWrap,
    TextOverflow overflow,
    int maxLines,
    Widget child,
  ) {
    this.style = style ?? this.style;
    this.textAlign = textAlign ?? this.textAlign;
    this.softWrap = softWrap ?? this.softWrap;
    this.overflow = overflow ?? this.overflow;
    this.maxLines = maxLines ?? this.maxLines;
    this.child = child ?? this.child;
    DefaultTextStyle oldWidget = _defaultTextStyle;
    _defaultTextStyle = null;
    DefaultTextStyle newWidget = defaultTextStyle;
    _defaultTextStyle = oldWidget;
    return newWidget;
  }

  ListTile get listTile {
    if (_listTile == null)
      _listTile = ListTile(
        key: Key('ListTile' + _key),
        leading: leading ?? onLeading(),
        title: title ?? onTitle(),
        subtitle: subtitle ?? onSubtitle(),
        trailing: trailing,
        isThreeLine: isThreeLine ?? false,
        dense: dense,
        contentPadding: contentPadding,
        enabled: enabled ?? true,
        onTap: tap ?? onTap,
        onLongPress: longPress ?? onLongPress,
        selected: selected ?? false,
      );
    return _listTile;
  }

  ListTile onListTile({
    Widget leading,
    Widget title,
    Widget subtitle,
    Widget trailing,
    bool isThreeLine,
    bool dense,
    EdgeInsetsGeometry contentPadding,
    bool enabled,
    GestureTapCallback tap,
    GestureLongPressCallback longPress,
    bool selected,
  }) {
    this.leading = leading ?? this.leading;
    this.title = title ?? this.title;
    this.subtitle = subtitle ?? this.subtitle;
    this.trailing = trailing ?? this.trailing;
    this.isThreeLine = isThreeLine ?? this.isThreeLine;
    this.dense = dense ?? this.dense;
    this.contentPadding = contentPadding ?? this.contentPadding;
    this.enabled = enabled ?? this.enabled;
    this.tap = tap ?? this.tap;
    this.longPress = longPress ?? this.longPress;
    this.selected = selected ?? this.selected;
    ListTile oldWidget = _listTile;
    _listTile = null;
    ListTile newWidget = listTile;
    _listTile = oldWidget;
    return newWidget;
  }

  //for LisTile
  Widget onLeading() => null;

  Widget onTitle() => text;

  // Override to produce a subtitle.
  Widget onSubtitle() => Text(label);

  Widget onTrailing() => null;

  // Override to place what happens when the field is tapped.
  void onTap() {}

  // Override to place what happens when the field is 'long' pressed.
  void onLongPress() {}

  CheckboxListTile get checkboxListTile {
    if (_checkboxListTile == null)
      _checkboxListTile = CheckboxListTile(
        key: Key('CheckboxListTile' + _key),
        value: _checkValue,
        onChanged: (bool v) => changed == null ? onChanged(v) : changed(v),
        activeColor: activeColor,
        title: title ?? onTitle(),
        subtitle: subtitle ?? onSubtitle(),
        isThreeLine: isThreeLine ?? false,
        dense: dense,
        secondary: secondary ?? onSecondary(),
        selected: selected ?? false,
        controlAffinity: controlAffinity,
      );
    return _checkboxListTile;
  }

  CheckboxListTile onCheckboxListTile({
    @required bool value,
    ValueChanged<bool> onChanged,
    Color activeColor,
    Widget title,
    Widget subtitle,
    bool isThreeLine,
    bool dense,
    Widget secondary,
    bool selected,
    ListTileControlAffinity controlAffinity,
  }) {
    _checkValue = value ?? _checkValue;
    this.changed = onChanged ?? this.changed;
    this.activeColor = activeColor ?? this.activeColor;
    this.title = title ?? this.title;
    this.subtitle = subtitle ?? this.subtitle;
    this.isThreeLine = isThreeLine ?? this.isThreeLine;
    this.dense = dense ?? this.dense;
    this.secondary = secondary ?? this.secondary;
    this.selected = selected ?? this.selected;
    this.controlAffinity = controlAffinity ?? this.controlAffinity;
    CheckboxListTile oldWidget = _checkboxListTile;
    _checkboxListTile = null;
    CheckboxListTile newWidget = checkboxListTile;
    _checkboxListTile = oldWidget;
    return newWidget;
  }

  // A widget to display on the opposite side of the tile from the checkbox.
  Widget onSecondary() => null;

  CircleAvatar get circleAvatar {
    if (_circleAvatar == null)
      _circleAvatar = CircleAvatar(
        key: Key('CircleAvatar' + _key),
        child: text,
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        foregroundColor: foregroundColor,
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
      );
    return _circleAvatar;
  }

  CircleAvatar onCircleAvatar(
    Color backgroundColor,
    Color foregroundColor,
    ImageProvider backgroundImage,
    double radius,
    double minRadius,
    double maxRadius,
  ) {
    this.backgroundColor = backgroundColor ?? this.backgroundColor;
    this.backgroundImage = backgroundImage ?? this.backgroundImage;
    this.foregroundColor = foregroundColor ?? this.foregroundColor;
    this.radius = radius ?? this.radius;
    this.minRadius = minRadius ?? this.minRadius;
    this.maxRadius = maxRadius ?? this.maxRadius;
    CircleAvatar oldWidget = _circleAvatar;
    _circleAvatar = null;
    CircleAvatar newWidget = circleAvatar;
    _circleAvatar = oldWidget;
    return newWidget;
  }

  Dismissible get dismissible {
    if (_dismissible == null)
      _dismissible = Dismissible(
        key: Key('Dismissible' + _key),
        child: child ?? onChild(),
        background: background ?? onBackground(),
        secondaryBackground: secondaryBackground ?? onSecondaryBackground(),
        onResize: resize ?? onResize,
        onDismissed: (DismissDirection direction) =>
            dismissed == null ? onDismissed(direction) : dismissed(direction),
        direction: direction ?? DismissDirection.endToStart,
        resizeDuration: resizeDuration ?? const Duration(milliseconds: 300),
        dismissThresholds:
            dismissThresholds ?? const <DismissDirection, double>{},
        movementDuration: movementDuration ?? const Duration(milliseconds: 200),
        crossAxisEndOffset: crossAxisEndOffset ?? 0.0,
      );
    return _dismissible;
  }

  Dismissible onDismissible({
    Widget child,
    Widget background,
    Widget secondaryBackground,
    VoidCallback resize,
    DismissDirectionCallback dismissed,
    DismissDirection direction,
    Duration resizeDuration,
    Map<DismissDirection, double> dismissThresholds,
    Duration movementDuration,
    double crossAxisEndOffset,
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
    Dismissible oldWidget = _dismissible;
    _dismissible = null;
    Dismissible newWidget = dismissible;
    _dismissible = oldWidget;
    return newWidget;
  }

  // Override to place a different child in the Dismissible.
  Widget onChild() {
    return Container(
        decoration: BoxDecoration(
            color: _theme.canvasColor,
            border: Border(bottom: BorderSide(color: _theme.dividerColor))),
        child: listTile);
  }

  // for Dismissible
  Widget onBackground() {
    return Container(
        color: Colors.red,
        child: const ListTile(
            trailing:
                const Icon(Icons.delete, color: Colors.white, size: 36.0)));
  }

  // Override to provide a secondary background.
  Widget onSecondaryBackground() => null;

  // Override to place what happens when the field is resized.
  void onResize() {}

  // Override to place here what happens when the field is dismissed.
  void onDismissed(DismissDirection direction) {}

  Checkbox get checkbox {
    if (_checkbox == null)
      _checkbox = Checkbox(
        key: Key('Checkbox' + _key),
        value: _checkValue,
        tristate: tristate,
        onChanged: (bool v) => changed == null ? onChanged(v) : changed(v),
        activeColor: activeColor,
        materialTapTargetSize: materialTapTargetSize,
      );
    return _checkbox;
  }

  Checkbox onCheckBox({
    @required bool value,
    ValueChanged<bool> onChanged,
    Color activeColor,
    bool tristate,
    MaterialTapTargetSize materialTapTargetSize,
  }) {
    _checkValue = value ?? _checkValue;
    this.changed = onChanged ?? this.changed;
    this.activeColor = activeColor ?? this.activeColor;
    this.tristate = tristate ?? this.tristate;
    this.materialTapTargetSize =
        materialTapTargetSize ?? this.materialTapTargetSize;
    Checkbox oldWidget = _checkbox;
    _checkbox = null;
    Checkbox newWidget = checkbox;
    _checkbox = oldWidget;
    return newWidget;
  }

  void onChanged(bool value) {}

  ListItems get listItems => ListItems(title: label, items: (value ?? [this]));

  ListItems onListItems({
    String title,
    List<DataFieldItem> items,
    MapItemFunction mapItem,
  }) {
    return ListItems(
      title: title ?? label,
      items: items ?? (value ?? [this]),
      mapItem: mapItem,
    );
  }

  ListItems get editItems => onListItems(mapItem: mapIt);

  Widget mapIt(DataFieldItem i) => ListTile(
        subtitle: Text(i.label ?? ""),
        title: textFormField,
        trailing: phoneTypes,
      );

  Widget phoneTypes = DropdownButton<String>(
    items: <String>['Home', 'Work', 'Mobile', 'Other'].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (_) {},
  );
}

/// Item class used for fields which only have a [label] and a [value]
class DataFieldItem {
  DataFieldItem({this.label, this.value});
  String label;
  dynamic value;
  String _label = 'label';
  String _value = 'value';

  DataFieldItem.fromMap(Map m, [String label, String value]) {
    keys(label, value);
    this.label = m[_label];
    this.value = m[_value];
  }

  keys(String label, String value) {
    if (label != null && label.isNotEmpty) _label = label;
    if (value != null && value.isNotEmpty) _value = value;
  }

  Map get toMap => {_label: label, _value: value};
}

class ListItems extends StatelessWidget {
  ListItems({this.title, this.items, this.mapItem});
  final String title;
  final List<DataFieldItem> items;
  final MapItemFunction mapItem;

  @override
  Widget build(BuildContext context) {
    MapItemFunction _map;
    if (mapItem == null) {
      _map = mapIt;
    } else {
      _map = mapItem;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(subtitle: Text(title)),
          Column(
              children: items
                  .map((i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _map(i)))
                  .toList())
        ]);
  }

  Widget mapIt(DataFieldItem i) =>
      ListTile(subtitle: Text(i.label ?? ""), title: Text(i.value ?? ""));
}

typedef Widget MapItemFunction(DataFieldItem i);

class _ChildForm extends StatelessWidget {
  _ChildForm({this.parent, this.child, Key key}) : super(key: key);
  final DataFields parent;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // Retrieve the Form's State object.
    parent._formState = Form.of(context);
    return child;
  }
}