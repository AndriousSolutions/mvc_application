///
/// Copyright (C) 2020 Andrious Solutions
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

class NavBottomBar {
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

  Key key;
  List<BottomNavigationBarItem> items;
  ValueChanged<int> onTap;
  int currentIndex;
  double elevation;
  BottomNavigationBarType type;
  Color fixedColor;
  Color backgroundColor;
  double iconSize;
  Color selectedItemColor;
  Color unselectedItemColor;
  IconThemeData selectedIconTheme;
  IconThemeData unselectedIconTheme;
  double selectedFontSize;
  double unselectedFontSize;
  TextStyle selectedLabelStyle;
  TextStyle unselectedLabelStyle;
  bool showSelectedLabels;
  bool showUnselectedLabels;
  bool hide;

  int _lastIndex = 0;

  @deprecated
  BottomNavigationBar get bar => show();

  /// Supply the defined BottomNavigationBar
  BottomNavigationBar show(
      {List<BottomNavigationBarItem> items,
      ValueChanged<int> onTap,
      int currentIndex,
      double elevation,
      BottomNavigationBarType type,
      Color fixedColor,
      Color backgroundColor,
      double iconSize,
      Color selectedItemColor,
      Color unselectedItemColor,
      IconThemeData selectedIconTheme,
      IconThemeData unselectedIconTheme,
      double selectedFontSize,
      double unselectedFontSize,
      TextStyle selectedLabelStyle,
      TextStyle unselectedLabelStyle,
      bool showSelectedLabels,
      bool showUnselectedLabels,
      bool hide}) {
    // In case null was directly assigned.
    this.hide ??= false;
    hide ??= this.hide;
    if (hide) return null;

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
      items: items ?? this.items,
      onTap: (int index) {
        this.currentIndex = index;
        _lastIndex = index;
        if (onTap != null) onTap(index);
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
