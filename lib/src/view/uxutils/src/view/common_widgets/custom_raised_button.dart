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
import 'package:flutter/material.dart';

/// A Elevated button with a built-in spinner
/// Used to convey an on-going process that completes with an enabled button.
@immutable
class CustomRaisedButton extends StatelessWidget {
  /// A constructor that takes in Elevated buttons properties.
  const CustomRaisedButton({
    Key? key,
    this.loading,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus,
    this.clipBehavior,
    required this.child,
  }) : super(key: key);

  /// A flag when True will enable the button.
  final bool? loading;

  /// Optional Callback function
  final VoidCallback? onPressed;

  /// Optional 'Long Press' Callback function
  final VoidCallback? onLongPress;

  /// Optional. Called when a pointer enters or exits the button response area.
  final ValueChanged<bool>? onHover;

  /// Optional. Called when the focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Customizes this button's appearance.
  final ButtonStyle? style;

  /// To obtain the keyboard focus and to handle keyboard events.
  final FocusNode? focusNode;

  /// If True, this widget will be selected as the initial focus when no other
  /// node in its scope is currently focused.
  final bool? autofocus;

  /// Different ways to clip a widget's content.
  final Clip? clipBehavior;

  /// Typically the button's label.
  final Widget? child;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: loading ?? false ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        clipBehavior: clipBehavior ?? Clip.none,
        child: loading ?? false ? buttonSpinner(context) : child,
      );

  /// Displays a Processing Indicator.
  Widget buttonSpinner(BuildContext context) {
    var data = Theme.of(context);
    data = data.copyWith(
        colorScheme: data.colorScheme.copyWith(secondary: Colors.white70));
    return Theme(
      data: data,
      child: const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
