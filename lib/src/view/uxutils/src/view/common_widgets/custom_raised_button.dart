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
///
///
import 'package:flutter/material.dart'
    show
        BuildContext,
        CircularProgressIndicator,
        Color,
        Colors,
        ElevatedButton,
        Key,
        SizedBox,
        StatelessWidget,
        Theme,
        VoidCallback,
        Widget,
        immutable;

@immutable
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key? key,
    required this.child,
    this.color,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 2.0,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);
  final Widget child;
  final Color? color;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback? onPressed;

  Widget buildSpinner(BuildContext context) {
    final data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: Colors.white70),
      child: const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          child: loading ? buildSpinner(context) : child,
      ),
      // RaisedButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(
      //       Radius.circular(borderRadius),
      //     ),
      //   ), // height / 2
      //   color: color,
      //   disabledColor: color,
      //   textColor: textColor,
      //   onPressed: onPressed,
      //   child: loading ? buildSpinner(context) : child,
      // ),
    );
  }
}
