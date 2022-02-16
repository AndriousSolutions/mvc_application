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
Future<bool> showBox({
  required BuildContext context,
  String? text,
  Option? button01,
  Option? button02,
  VoidCallback? press01,
  VoidCallback? press02,
  Widget? title,
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleTextStyle,
  Widget? content,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? contentTextStyle,
  List<Widget>? actions,
  EdgeInsetsGeometry? actionsPadding,
  VerticalDirection? actionsOverflowDirection,
  double? actionsOverflowButtonSpacing,
  EdgeInsetsGeometry? buttonPadding,
  Color? backgroundColor,
  double? elevation,
  String? semanticLabel,
  EdgeInsets? insetPadding,
  Clip? clipBehavior,
  ShapeBorder? shape,
  bool? scrollable,
  bool? barrierDismissible,
  Color? barrierColor,
  String? barrierLabel,
  bool? useSafeArea,
  bool? useRootNavigator,
  RouteSettings? routeSettings,
}) async {
  button01 ??= OKOption();
  button02 ??= CancelOption();
  bool? result;
  if (App.useMaterial) {
    result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      barrierColor: barrierColor ?? Colors.black54,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea ?? true,
      useRootNavigator: useRootNavigator ?? true,
      routeSettings: routeSettings,
      builder: (BuildContext context) => AlertDialog(
          title: title,
          titlePadding: titlePadding,
          titleTextStyle: titleTextStyle,
          content: content ?? Text(text ?? ' '),
          contentPadding:
              contentPadding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
          contentTextStyle: contentTextStyle,
          actionsPadding: actionsPadding ?? EdgeInsets.zero,
          actionsOverflowDirection: actionsOverflowDirection,
          actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
          buttonPadding: buttonPadding,
          backgroundColor: backgroundColor,
          elevation: elevation,
          semanticLabel: semanticLabel,
          insetPadding: insetPadding ??
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          clipBehavior: clipBehavior ?? Clip.none,
          shape: shape,
          scrollable: scrollable ?? false,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (press02 != null) {
                  press02();
                }
                if (button02!.onPressed != null) {
                  button02.onPressed!();
                }
                Navigator.pop(context, button02.result ?? false);
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
                Navigator.pop(context, button01.result ?? true);
              },
              child: Text(button01!.text ?? 'OK'),
            ),
          ]),
    );
  } else {
    result = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(content: Text(text ?? ' '), actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            if (press02 != null) {
              press02();
            }
            if (button02!.onPressed != null) {
              button02.onPressed!();
            }
            Navigator.pop(context, button02.result ?? false);
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
            Navigator.pop(context, button01.result ?? true);
          },
          child: Text(button01!.text ?? 'OK'),
        ),
      ]),
    );
  }
  return result ?? false;
}

/// A high-level function
/// Displays a String passing specific one to two button options
/// and their corresponding function calls.
void dialogBox({
  String? title,
  Option? button01,
  Option? button02,
  VoidCallback? press01,
  VoidCallback? press02,
  bool barrierDismissible = false,
  bool switchButtons = false,
}) {
  showDialog<bool>(
      context: App.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return _DialogWindow(
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
    this.title,
    Option? button01,
    Option? button02,
    VoidCallback? press01,
    VoidCallback? press02,
    bool? switchButtons,
  }) {
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

/// A mixin to work with the class [DialogBox]
/// or can be assigned to any class involving
/// two buttons and their callback routines.
mixin DialogOptions {
  /// First button option
  Option? button01;

  /// Second button option
  Option? button02;

  /// First button's callback function
  VoidCallback? press01;

  /// Second button's callback function
  VoidCallback? press02;

  /// Boolean flag to switch display order of buttons.
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
          Navigator.pop(App.context!, option.result);
        },
        child: Text(option.text!),
      );
}

/// The Button Option Class
class Option {
  /// Supply the button's text, callback and dynamic result value.
  Option({this.text, this.onPressed, this.result})
      : assert(result != null, 'Must provide a option result!');

  /// The optional Button Text label.
  final String? text;

  /// The optional callback function
  final VoidCallback? onPressed;

  /// The result of any type that's assigned when the button is pressed.
  final dynamic result;
}

/// The 'OK' Button Option
class OKOption extends Option {
  /// Supply the optionally Callback when pressed.
  /// Assigns a boolean True to the result property.
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

/// The 'Cancel' Button Option
class CancelOption extends Option {
  /// Supply the optionally Callback when pressed.
  /// Assigns a boolean False to the result property.
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

/// Message Box Class
class MsgBox {
  /// Supply a Message box
  const MsgBox({
    required this.context,
    this.title,
    this.msg,
    this.body,
    this.actions,
  });

  /// Requires a BuildContext
  final BuildContext context;

  /// Optional String to display as a title on the Message box.
  final String? title;

  /// Optional String as the primary message of the Message box.
  final String? msg;

  /// Optional List of Widgets that take precedence over [msg]
  /// and will be displayed instead.
  final List<Widget>? body;

  /// Optional set of actions that are displayed at the bottom of the
  /// Message box.
  final List<Widget>? actions;

  /// Call to display this Message box.
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
  /// Supply the Dialog window's buttons and Callback routines.
  DialogBox({
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
    this.button01 = button01;
    this.button02 = button02;
    this.press01 = press01;
    this.press02 = press02;
    this.switchButtons = switchButtons;
  }

  /// The Dialog window's title.
  final String? title;

  /// The Dialog window's title.
  final List<Widget>? body;

  /// The Dialog window's title.
  final List<Widget>? actions;

  /// Whether or not the Dialog window disables the rest of the interface or not.
  final bool? barrierDismissible;

  /// Display the Dialog window.
  Future<void> show({
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
    title = title ?? this.title;
    title ??= '';
    this.button01 ??= button01;
    this.button02 ??= button02;
    this.press01 ??= press01;
    this.press02 ??= press02;
    this.switchButtons ??= switchButtons;
    body = body ?? this.body;
    body ??= [const SizedBox()];
    actions ??= this.actions;
    actions ??= _listOptions();
    barrierDismissible ??= this.barrierDismissible ?? false;
    return showDialog<void>(
        context: App.context!,
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
