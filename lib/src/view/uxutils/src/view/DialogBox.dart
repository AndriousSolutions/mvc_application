////
//// Copyright (C) 2019 Andrious Solutions
////
//// This program is free software; you can redistribute it and/or
//// modify it under the terms of the GNU General Public License
//// as published by the Free Software Foundation; either version 3
//// of the License, or any later version.
////
//// You may obtain a copy of the License at
////
////  http://www.apache.org/licenses/LICENSE-2.0
////
////
//// Unless required by applicable law or agreed to in writing, software
//// distributed under the License is distributed on an "AS IS" BASIS,
//// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//// See the License for the specific language governing permissions and
//// limitations under the License.
////
////          Created  05 Feb 2019
////
//// DialogBox.dart
//
//import 'package:flutter/material.dart';
//
//import 'package:flutter/cupertino.dart';
//
//import 'package:mvc_application/view.dart';
//
//Future<bool> showBox({
//  @required BuildContext context,
//  String text,
//  Option<bool> button01,
//  Option<bool> button02,
//  VoidCallback press01,
//  VoidCallback press02,
//}) {
//  if (button01 == null) {
//    button01 = OKOption();
//  }
//  if (button02 == null) {
//    button02 = CancelOption();
//  }
//  final ThemeData theme = Theme.of(context);
//  final TextStyle dialogTextStyle =
//      theme.textTheme.subtitle1.copyWith(color: theme.textTheme.caption.color);
//  if (App.useMaterial) {
//    return showDialog<bool>(
//      context: context,
//      builder: (BuildContext context) => AlertDialog(
//          content: Text(text ?? ' ', style: dialogTextStyle),
//          actions: <Widget>[
//            FlatButton(
//                child: Text(button02.text ?? 'Cancel'),
//                onPressed: () {
//                  if (press02 != null) press02();
//                  if (button02.onPressed != null) button02.onPressed();
//                  Navigator.pop(context, button02.result);
//                }),
//            FlatButton(
//                child: Text(button01.text ?? 'OK'),
//                onPressed: () {
//                  if (press01 != null) press01();
//                  if (button01.onPressed != null) button01.onPressed();
//                  Navigator.pop(context, button01.result);
//                }),
//          ]),
//    );
//  } else {
//    return showCupertinoDialog<bool>(
//      context: context,
//      builder: (BuildContext context) => CupertinoAlertDialog(
//          content: Text(text ?? ' ', style: dialogTextStyle),
//          actions: <Widget>[
//            CupertinoDialogAction(
//                child: Text(button02.text ?? 'Cancel'),
//                onPressed: () {
//                  if (press02 != null) press02();
//                  if (button02.onPressed != null) button02.onPressed();
//                  Navigator.pop(context, button02.result);
//                }),
//            CupertinoDialogAction(
//                child: Text(button01.text ?? 'OK'),
//                onPressed: () {
//                  if (press01 != null) press01();
//                  if (button01.onPressed != null) button01.onPressed();
//                  Navigator.pop(context, button01.result);
//                }),
//          ]),
//    );
//  }
//}
//
//void dialogBox({
//  @required BuildContext context,
//  String title,
//  Option button01,
//  Option button02,
//  VoidCallback press01,
//  VoidCallback press02,
//  bool barrierDismissible = false,
//}) {
//  showDialog<bool>(
//      context: context,
//      barrierDismissible: barrierDismissible,
//      builder: (BuildContext context) {
//        return _DialogWindow(
//                context: context,
//                title: title,
//                button01: button01,
//                button02: button02,
//                press01: press01,
//                press02: press02)
//            .show();
//      });
//}
//
//class _DialogWindow {
//  _DialogWindow(
//      {@required this.context,
//      this.title,
//      this.button01,
//      this.button02,
//      this.press01,
//      this.press02});
//
//  final BuildContext context;
//  final String title;
//  final Option button01;
//  final Option button02;
//  final VoidCallback press01;
//  final VoidCallback press02;
//
//  SimpleDialog show() {
//    return SimpleDialog(
//      title: Text(title ?? ' '),
//      children: _listOptions(),
//    );
//  }
//
//  List<Widget> _listOptions() {
//    List<Widget> opList = [];
//    Option option;
//    if (button01 != null || press01 != null) {
//      option = Option<bool>(
//          text: button01?.text ?? 'OK',
//          onPressed: press01 ?? button01.onPressed,
//          result: true);
//    } else {
//      option = OKOption();
//    }
//    opList.add(_simpleOption(option));
//    if (button02 != null || press02 != null) {
//      option = Option(
//          text: button02?.text ?? 'Cancel',
//          onPressed: press02 ?? button02.onPressed);
//      opList.add(_simpleOption(option));
//    } else {
//      if (option is! OKOption) {
//        option = CancelOption();
//        opList.add(_simpleOption(option));
//      }
//    }
//    return opList;
//  }
//
//  Widget _simpleOption(Option option) {
//    return SimpleDialogOption(
//      child: Text(option.text),
//      onPressed: () {
//        if (option.onPressed != null) option.onPressed();
//        Navigator.pop(context, option.result);
//      },
//    );
//  }
//}
//
//class Option<T> {
//  Option({this.text, this.onPressed, this.result}) {
//    assert(result != null, 'Must provide a option result!');
//  }
//  final String text;
//  final VoidCallback onPressed;
//  final T result;
//}
//
//class OKOption extends Option<bool> {
//  OKOption({VoidCallback onPressed})
//      : super(
//          text: 'OK',
//          onPressed: () {
//            if (onPressed != null) onPressed();
//          },
//          result: true,
//        );
//}
//
//class CancelOption extends Option<bool> {
//  CancelOption({VoidCallback onPressed})
//      : super(
//          text: 'Cancel',
//          onPressed: () {
//            if (onPressed != null) onPressed();
//          },
//          result: false,
//        );
//}
//
//class MsgBox {
//  MsgBox({@required this.context, this.title, this.msg, this.body});
//  final BuildContext context;
//  final String title;
//  final String msg;
//  final List<Widget> body;
//
//  Future<void> show({
//    BuildContext context,
//    String title,
//    String msg,
//    List<Widget> body,
//  }) {
//    context = context ?? this.context;
//    title = title ?? this.title;
//    msg = msg ?? this.msg;
//    body = body ?? this.body;
//    List<Widget> _body;
//    if (body != null) {
//      _body = body;
//    } else {
//      if (msg == null || msg.isEmpty) {
//        _body = [Text('Shall we oontinue?')];
//      } else {
//        _body = [Text(msg)];
//      }
//    }
//    return showDialog<void>(
//        context: context,
//        barrierDismissible: false,
//        builder: (BuildContext context) => AlertDialog(
//              title: Text(title ?? ''),
//              content: SingleChildScrollView(
//                child: ListBody(
//                  children: _body,
//                ),
//              ),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text('OK'),
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                ),
//              ],
//            ));
//  }
//}
