///
/// Copyright (C) 2020 Andrious Solutions
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
///          Created  16 Jan 2020
///
///

import 'package:flutter/material.dart'
    show
        BottomNavigationBar,
        BottomNavigationBarItem,
        BottomNavigationBarType,
        Color,
        IconThemeData,
        Key,
        TextStyle,
        ValueChanged;

/// BottomNavigationBar Wrapper Class.
class NavBottomBar {
  /// Optionally supply all the BottomNavigationBar properties when instantiating.
  NavBottomBar({
    this.key,
    this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation = 8.0,
    this.type,
    this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    this.showUnselectedLabels,
    this.hide = false,
  });

  /// The Widget Key.
  Key? key;

  /// Defines the appearance of the button items that are arrayed within the
  /// bottom navigation bar.
  List<BottomNavigationBarItem>? items;

  /// Called when one of the [items] is tapped.
  ValueChanged<int>? onTap;

  /// The index into [items] for the current active [BottomNavigationBarItem].
  int? currentIndex;

  /// The z-coordinate of this [BottomNavigationBar].
  double? elevation;

  /// Defines the layout and behavior of a [BottomNavigationBar].
  BottomNavigationBarType? type;

  /// The value of [selectedItemColor].
  Color? fixedColor;

  /// The color of the [BottomNavigationBar] itself.
  Color? backgroundColor;

  /// The size of all of the [BottomNavigationBarItem] icons.
  double? iconSize;

  /// The color of the selected [BottomNavigationBarItem.icon]
  Color? selectedItemColor;

  /// The color of the unselected [BottomNavigationBarItem.icon] and
  Color? unselectedItemColor;

  /// The size, opacity, and color of the icon in the currently selected
  /// [BottomNavigationBarItem.icon].
  IconThemeData? selectedIconTheme;

  /// The size, opacity, and color of the icon in the currently unselected
  /// [BottomNavigationBarItem.icon]s.
  IconThemeData? unselectedIconTheme;

  /// The [TextStyle] of the [BottomNavigationBarItem] labels when they are
  /// selected.
  TextStyle? selectedLabelStyle;

  /// The [TextStyle] of the [BottomNavigationBarItem] labels when they are not
  /// selected.
  TextStyle? unselectedLabelStyle;

  /// The font size of the [BottomNavigationBarItem] labels when they are selected.
  double? selectedFontSize;

  /// The font size of the [BottomNavigationBarItem] labels when they are not
  /// selected.
  double? unselectedFontSize;

  /// Whether the labels are shown for the unselected [BottomNavigationBarItem]s.
  bool? showSelectedLabels;

  /// Whether the labels are shown for the selected [BottomNavigationBarItem].
  bool? showUnselectedLabels;

  /// If true the show() funciton will not work. Bottom Bar is not displayed.
  bool? hide;

  int _lastIndex = 0;

  /// Display the defined BottomNavigationBar
  @Deprecated('Use show() instead.')
  BottomNavigationBar? get bar => show();

  /// Display the defined BottomNavigationBar
  BottomNavigationBar? show(
      {List<BottomNavigationBarItem>? items,
      ValueChanged<int>? onTap,
      int? currentIndex,
      double? elevation,
      BottomNavigationBarType? type,
      Color? fixedColor,
      Color? backgroundColor,
      double? iconSize,
      Color? selectedItemColor,
      Color? unselectedItemColor,
      IconThemeData? selectedIconTheme,
      IconThemeData? unselectedIconTheme,
      double? selectedFontSize,
      double? unselectedFontSize,
      TextStyle? selectedLabelStyle,
      TextStyle? unselectedLabelStyle,
      bool? showSelectedLabels,
      bool? showUnselectedLabels,
      bool? hide}) {
    // In case null was directly assigned.
    this.hide ??= false;
    hide ??= this.hide;
    if (hide!) {
      return null;
    }

    // If directly assigned an invalid index
    currentIndex ??= this.currentIndex;

    if (currentIndex == null || currentIndex < 0) {
      currentIndex = _lastIndex;
    }
    if (items != null && currentIndex > items.length - 1) {
      currentIndex = _lastIndex;
    }

    // Supply the original routine if any.
    onTap ??= this.onTap;

    return BottomNavigationBar(
      key: key,
      items: items ?? this.items!,
      onTap: (int index) {
        this.currentIndex = index;
        _lastIndex = index;
        if (onTap != null) {
          onTap(index);
        }
      },
      currentIndex: currentIndex,
      elevation: elevation ?? this.elevation ?? 8.0,
      type: type ?? this.type,
      fixedColor: fixedColor ?? this.fixedColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconSize: iconSize ?? this.iconSize ?? 24.0,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      selectedIconTheme:
          selectedIconTheme ?? this.selectedIconTheme ?? const IconThemeData(),
      unselectedIconTheme: unselectedIconTheme ??
          this.unselectedIconTheme ??
          const IconThemeData(),
      selectedFontSize: selectedFontSize ?? this.selectedFontSize ?? 14.0,
      unselectedFontSize: unselectedFontSize ?? this.unselectedFontSize ?? 12.0,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      showSelectedLabels: showSelectedLabels ?? this.showSelectedLabels ?? true,
      showUnselectedLabels: showUnselectedLabels ?? this.showUnselectedLabels,
    );
  }

  /// Copy this to supply all the parameters if you want.
//  SubClassName(
//      {Key key,
//      List<BottomNavigationBarItem> items,
//      ValueChanged<int> onTap,
//      int currentIndex,
//      double elevation,
//      BottomNavigationBarType type,
//      Color fixedColor,
//      Color backgroundColor,
//      double iconSize,
//      Color selectedItemColor,
//      Color unselectedItemColor,
//      IconThemeData selectedIconTheme,
//      IconThemeData unselectedIconTheme,
//      double selectedFontSize,
//      double unselectedFontSize,
//      TextStyle selectedLabelStyle,
//      TextStyle unselectedLabelStyle,
//      bool showSelectedLabels,
//      bool showUnselectedLabels,
//      bool hide})
//      : super(
//            key: key,
//            items: items,
//            onTap: onTap,
//            currentIndex: currentIndex,
//            elevation: elevation,
//            type: type,
//            fixedColor: fixedColor,
//            backgroundColor: backgroundColor,
//            iconSize: iconSize,
//            selectedItemColor: selectedItemColor,
//            unselectedItemColor: unselectedItemColor,
//            selectedIconTheme: selectedIconTheme,
//            unselectedIconTheme: unselectedIconTheme,
//            selectedFontSize: selectedFontSize,
//            unselectedFontSize: unselectedFontSize,
//            selectedLabelStyle: selectedLabelStyle,
//            unselectedLabelStyle: unselectedLabelStyle,
//            showSelectedLabels: showSelectedLabels,
//            showUnselectedLabels: showUnselectedLabels,
//            hide: hide);
}
