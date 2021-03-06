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
///          Created  05 Feb 2019
///

import 'package:mvc_application/view.dart';

/// A high-level function
/// Displays a String passing specific one to two button options
/// and their corresponding fucntion calls.
/// Displays a particular dialogue box depending on platform.
Future<bool?> showBox({
  required BuildContext context,
  String? text,
  Option? button01,
  Option? button02,
  VoidCallback? press01,
  VoidCallback? press02,
}) {
  button01 ??= OKOption();
  button02 ??= CancelOption();
  final theme = Theme.of(context);
  final dialogTextStyle = theme.textTheme.subtitle1!
      .copyWith(color: theme.textTheme.caption!.color);
  if (App.useMaterial) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          content: Text(text ?? ' ', style: dialogTextStyle),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (press02 != null) {
                  press02();
                }
                if (button02!.onPressed != null) {
                  button02.onPressed!();
                }
                Navigator.pop(context, button02.result);
              },
              child: Text(button02!.text ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (press01 != null) {
                  press01();
                }
                if (button01!.onPressed != null) {
                  button01.onPressed!();
                }
                Navigator.pop(context, button01.result);
              },
              child: Text(button01!.text ?? 'OK'),
            ),
          ]),
    );
  } else {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
          content: Text(text ?? ' ', style: dialogTextStyle),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                if (press02 != null) {
                  press02();
                }
                if (button02!.onPressed != null) {
                  button02.onPressed!();
                }
                Navigator.pop(context, button02.result);
              },
              child: Text(button02!.text ?? 'Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (press01 != null) {
                  press01();
                }
                if (button01!.onPressed != null) {
                  button01.onPressed!();
                }
                Navigator.pop(context, button01.result);
              },
              child: Text(button01!.text ?? 'OK'),
            ),
          ]),
    );
  }
}

/// A high-level function
/// Displays a String passing specific one to two button options
/// and their corresponding function calls.
void dialogBox({
  required BuildContext context,
  String? title,
  Option? button01,
  Option? button02,
  VoidCallback? press01,
  VoidCallback? press02,
  bool barrierDismissible = false,
  bool switchButtons = false,
}) {
  showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return _DialogWindow(
          context: context,
          title: title,
          button01: button01,
          button02: button02,
          press01: press01,
          press02: press02,
          switchButtons: switchButtons,
        ).show();
      });
}

class _DialogWindow with DialogOptions {
  _DialogWindow({
    required BuildContext context,
    this.title,
    Option? button01,
    Option? button02,
    VoidCallback? press01,
    VoidCallback? press02,
    bool? switchButtons,
  }) {
    this.context = context;
    this.button01 = button01;
    this.button02 = button02;
    this.press01 = press01;
    this.press02 = press02;
    this.switchButtons = switchButtons;
  }
  final String? title;

  SimpleDialog show() {
    return SimpleDialog(
      title: Text(title ?? ' '),
      children: _listOptions(),
    );
  }
}

mixin DialogOptions {
  BuildContext? context;
  Option? button01;
  Option? button02;
  VoidCallback? press01;
  VoidCallback? press02;
  bool? switchButtons;

  List<Widget> _listOptions() {
    final opList = <Widget>[];
    Option option01, option02;

    if (button01 != null || press01 != null) {
      option01 = Option(
          text: button01?.text ?? 'Cancel',
          onPressed: press01 ?? button01!.onPressed,
          result: true);
    } else {
      option01 = CancelOption();
    }
    if (button02 != null || press02 != null) {
      option02 = Option(
          text: button02?.text ?? 'OK',
          onPressed: press02 ?? button02!.onPressed,
          result: false);
    } else {
      if (option01 is! OKOption) {
        option02 = OKOption();
        opList.add(_simpleOption(option02));
      } else {
        option02 = CancelOption();
      }
    }
    if (switchButtons != null && switchButtons!) {
      opList.add(_simpleOption(option02));
      opList.add(_simpleOption(option01));
    } else {
      opList.add(_simpleOption(option01));
      opList.add(_simpleOption(option02));
    }
    return opList;
  }

  Widget _simpleOption(Option option) => SimpleDialogOption(
        onPressed: () {
          if (option.onPressed != null) {
            option.onPressed!();
          }
          Navigator.pop(context!, option.result);
        },
        child: Text(option.text!),
      );
}

class Option {
  Option({this.text, this.onPressed, required this.result})
      : assert(result != null, 'Must provide a option result!');
  final String? text;
  final VoidCallback? onPressed;
  final dynamic result;
}

class OKOption extends Option {
  OKOption({VoidCallback? onPressed})
      : super(
          text: 'OK',
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          result: true,
        );
}

class CancelOption extends Option {
  CancelOption({VoidCallback? onPressed})
      : super(
          text: 'Cancel',
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          result: false,
        );
}

class MsgBox {
  const MsgBox({
    required this.context,
    this.title,
    this.msg,
    this.body,
    this.actions,
  });
  final BuildContext context;
  final String? title;
  final String? msg;
  final List<Widget>? body;
  final List<Widget>? actions;

  Future<void> show({
    BuildContext? context,
    String? title,
    String? msg,
    List<Widget>? body,
    List<Widget>? actions,
  }) {
    context = context ?? this.context;
    title = title ?? this.title;
    msg = msg ?? this.msg;
    body = body ?? this.body;
    if (body == null) {
      if (msg == null || msg.isEmpty) {
        body = [const Text('Shall we continue?')];
      } else {
        body = [Text(msg)];
      }
    }
    actions = actions ?? this.actions;
    actions ??= <Widget>[
      TextButton(
        onPressed: () {
          Navigator.pop(context!);
        },
        child: const Text('OK'),
      ),
    ];
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title ?? ''),
              content: SingleChildScrollView(
                child: ListBody(
                  children: body!,
                ),
              ),
              actions: actions,
            ));
  }
}

/// Display an extensive widget to a dialogue window.
///
class DialogBox with DialogOptions {
  DialogBox({
    required BuildContext context,
    this.title,
    Option? button01,
    Option? button02,
    VoidCallback? press01,
    VoidCallback? press02,
    bool? switchButtons,
    this.body,
    this.actions,
    this.barrierDismissible = false,
  }) {
    this.context = context;
    this.button01 = button01;
    this.button02 = button02;
    this.press01 = press01;
    this.press02 = press02;
    this.switchButtons = switchButtons;
  }
  final String? title;
  final List<Widget>? body;
  final List<Widget>? actions;
  final bool? barrierDismissible;

  Future<void> show({
    BuildContext? context,
    String? title,
    Option? button01,
    Option? button02,
    VoidCallback? press01,
    VoidCallback? press02,
    bool? switchButtons,
    String? msg,
    List<Widget>? body,
    List<Widget>? actions,
    bool? barrierDismissible,
  }) {
    context = context ?? this.context;
    title = title ?? this.title;
    title ??= '';
    this.button01 ??= button01;
    this.button02 ??= button02;
    this.press01 ??= press01;
    this.press02 ??= press02;
    this.switchButtons ??= switchButtons;
    body = body ?? this.body;
    body ??= [Container()];
    actions ??= this.actions;
    actions ??= _listOptions();
    barrierDismissible ??= this.barrierDismissible ?? false;
    return showDialog<void>(
        context: context!,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title!),
              content: SingleChildScrollView(
                child: ListBody(
                  children: body!,
                ),
              ),
              actions: actions,
            ));
  }
}
