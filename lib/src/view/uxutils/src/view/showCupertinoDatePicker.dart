///
/// Copyright (C) 2019 Andrious Solutions Ltd.
/// adaptation from Miguel Ruivo  https://github.com/miguelpruivo
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
///          Created  03 Mar 2020
///
///

import 'dart:ui' show ImageFilter;
export 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart'
    show
        Alignment,
        Border,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Color,
        Column,
        Container,
        CrossAxisAlignment,
        CupertinoButton,
        CupertinoDatePicker,
        CupertinoDatePickerMode,
        CupertinoIcons,
        CupertinoTheme,
        CupertinoThemeData,
        EdgeInsets,
        Expanded,
        FontWeight,
        Icon,
        Key,
        MainAxisAlignment,
        Navigator,
        required,
        Row,
        SizedBox,
        Text,
        Widget,
        showCupertinoModalPopup;

import 'package:flutter/material.dart' show Color, Colors;
export 'package:flutter/material.dart' show Color, Colors;

void showCupertinoDatePicker(
  BuildContext context, {
  Key key,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
  @required Function(DateTime value) onDateTimeChanged,
  DateTime initialDateTime,
  DateTime minimumDate,
  DateTime maximumDate,
  int minimumYear = 1,
  int maximumYear,
  int minuteInterval = 1,
  bool use24hFormat = false,
  Color backgroundColor,
  ImageFilter filter,
  bool useRootNavigator = true,
  bool semanticsDismissible,
  Widget cancelText,
  Widget doneText,
  bool useText = false,
  bool leftHanded = false,
}) {
  // Default to right now.
  initialDateTime ??= DateTime.now();

  // Retrieve the current 'theme'
  final CupertinoThemeData theme = CupertinoTheme.of(context);
  
  // Assign the spinner's background colour.
  backgroundColor ??= theme.scaffoldBackgroundColor;

  if (!useText) {
    cancelText = Icon(CupertinoIcons.clear_circled);
  } else {
    if (cancelText == null)
      cancelText = Text(
        'Cancel',
        style: theme.textTheme.actionTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
      );
  }

  if (!useText) {
    doneText = Icon(CupertinoIcons.check_mark_circled);
  } else {
    if (doneText == null)
      doneText = Text(
        'Save',
        style: theme
            .textTheme
            .actionTextStyle
            .copyWith(fontWeight: FontWeight.w600),
      );
  }

  var cancelButton = CupertinoButton(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: cancelText,
    onPressed: () {
      onDateTimeChanged(DateTime(0000, 01, 01, 0, 0, 0, 0, 0));
      Navigator.of(context).pop();
    },
  );

  var doneButton = CupertinoButton(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: doneText,
    onPressed: () => Navigator.of(context).pop(),
  );

  //
  showCupertinoModalPopup(
    context: context,
    builder: (context) => SizedBox(
      height: 240.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 249, 247, 1.0),
              border: Border(
                bottom: const BorderSide(width: 0.5, color: Colors.black38),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                leftHanded ? doneButton : cancelButton,
                leftHanded ? cancelButton : doneButton,
              ],
            ),
          ),
          Expanded(
              child: CupertinoDatePicker(
            key: key,
            mode: mode,
            onDateTimeChanged: (DateTime value) {
              if (onDateTimeChanged == null) return;
              if (mode == CupertinoDatePickerMode.time) {
                onDateTimeChanged(
                    DateTime(0000, 01, 01, value.hour, value.minute));
              } else {
                onDateTimeChanged(value);
              }
            },
            initialDateTime: initialDateTime,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
            minuteInterval: minuteInterval,
            use24hFormat: use24hFormat,
            backgroundColor: backgroundColor,
          )),
        ],
      ),
    ),
    filter: filter,
    useRootNavigator: useRootNavigator,
    semanticsDismissible: semanticsDismissible,
  );
}
