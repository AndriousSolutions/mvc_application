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
///          Created  11 Sep 2018
///

import 'package:flutter/material.dart'
    show
        AlignmentDirectional,
        BoxConstraints,
        BuildContext,
        Container,
        DefaultTextStyle,
        EdgeInsets,
        EdgeInsetsDirectional,
        FlatButton,
        IconTheme,
        Key,
        MediaQuery,
        MergeSemantics,
        StatelessWidget,
        Text,
        TextOverflow,
        TextSpan,
        TextStyle,
        Theme,
        VoidCallback,
        Widget,
        required,
        showAboutDialog;

import 'package:flutter/gestures.dart' show TapGestureRecognizer;

import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:flutter/foundation.dart' as Plat show defaultTargetPlatform;

class AppSettings {
  static get defaultTargetPlatform => Plat.defaultTargetPlatform;

  static StatelessWidget tapText(String text, VoidCallback onTap,
      {TextStyle style}) {
    return _TapText(text, onTap, style: style);
  }

  static _LinkTextSpan linkTextSpan(
      {TextStyle style, String url, String text}) {
    return _LinkTextSpan(style: style, url: url, text: text);
  }

  static void showAbout({
    @required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
  }) {
    showAboutDialog(
      context: context,
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
      children: children,
    );
  }
}

class _TapText extends StatelessWidget {
  const _TapText(this.text, this.onTap, {this.style});

  final String text;
  final VoidCallback onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: _FlatButton(
        onPressed: onTap,
        child: Text(text),
        style: style,
      ),
    );
  }
}

class _OptionsItem extends StatelessWidget {
  const _OptionsItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        constraints: BoxConstraints(
            minHeight: 48.0 * MediaQuery.textScaleFactorOf(context)),
        padding: EdgeInsetsDirectional.only(start: 56.0),
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child: IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _FlatButton extends StatelessWidget {
  const _FlatButton({
    Key key,
    this.onPressed,
    this.child,
    this.style,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    Widget child = style == null
        ? this.child
        : DefaultTextStyle(
            style: style,
            child: this.child,
          );
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: child,
    );
  }
}

class _LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}
