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
///          Created  09 Feb 2019
///
///

import 'package:mvc_application/view.dart';

/// Exports that will be likely required by the subclass.
export 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        EdgeInsets,
        EdgeInsetsGeometry,
        Key,
        Offset,
        PopupMenuButton,
        PopupMenuCanceled,
        PopupMenuDivider,
        PopupMenuEntry,
        PopupMenuItem,
        PopupMenuItemBuilder,
        PopupMenuItemSelected,
        Scaffold,
        ShapeBorder,
        SnackBar,
        Text,
        Widget;

/// A generic class to provide the App's popup menu.
class AppMenu {
  /// The App's popup is instantiated only once.
  factory AppMenu() => _this ??= AppMenu._();
  AppMenu._();
  static AppMenu? _this;

  static StateMVC? _state;

  Menu? _menu;
  String? _applicationName;
  String? _applicationVersion;
  Widget? _applicationIcon;
  String? _applicationLegalese;
  List<Widget>? _children;

  /// Display the popup menu.
  PopupMenuButton<dynamic> show(
    StateMVC state, {
    String? applicationName,
    Widget? applicationIcon,
    String? applicationLegalese,
    List<Widget>? children,
    bool useRootNavigator = true,
    Menu? menu,
  }) {
    _state = state;
    _menu = menu;
    _applicationName = applicationName;
    _applicationVersion = 'version: ${App.version} build: ${App.buildNumber}';
    _applicationIcon = applicationIcon;
    _applicationLegalese = applicationLegalese;
    _children = children;

    var menuItems = <PopupMenuEntry<dynamic>>[
//      PopupMenuItem<dynamic>(value: 'Color', child: I10n.t('Colour Theme')),
      PopupMenuItem<dynamic>(value: 'About', child: L10n.t('About'))
    ];

    if (_menu != null) {
      final temp = <PopupMenuEntry<dynamic>>[
        ..._menu!.menuItems(),
        const PopupMenuDivider(),
        ...menuItems
      ];
      menuItems = temp;

      if (_menu!.tailItems.isNotEmpty) {
        menuItems.add(const PopupMenuDivider());
        menuItems.addAll(_menu!.tailItems);
      }
    }

    return PopupMenuButton<dynamic>(
      onSelected: _showMenuSelection,
      itemBuilder: (BuildContext context) => menuItems,
    );
  }

  void _showMenuSelection(dynamic value) {
    if (_menu != null) {
      _menu!.onSelected(value);
    }
    if (value is! String) {
      return;
    }
    switch (value) {
      case 'About':
        showAboutDialog(
            context: _state!.context,
            applicationName: L10n.s(_applicationName ?? App.vw?.title ?? ''),
            applicationVersion: _applicationVersion,
            applicationIcon: _applicationIcon,
            applicationLegalese: _applicationLegalese,
            children: _children);
        break;
      default:
    }
  }
}

/// Abstract class to implement the App's popup menu.
abstract class Menu {
  /// Called to instantiate an App popup menu object.
  Menu() : _appMenu = AppMenu();
  final AppMenu _appMenu;

  /// The List of defined Popup Menu Items at the tail end of the menu.
  List<PopupMenuItem<dynamic>> tailItems = [];

  /// The List of defined Popup Menu Items.
  List<PopupMenuItem<dynamic>> menuItems();

  /// Called when a menu item is selected.
  void onSelected(dynamic menuItem);

  /// Display the popup menu.
  /// Passed in a 'State' object and the Application's very name.
  PopupMenuButton<dynamic> show(StateMVC state, {String? applicationName}) =>
      _appMenu.show(
        state,
        applicationName: applicationName,
        menu: this,
      );
}

/// Abstract class to create a customized [PopupMenuButton].
abstract class AppPopupMenu<T> {
  /// Supply all the properties to instantiate a custom [PopupMenuButton].
  AppPopupMenu({
    this.key,
    this.items,
    this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8),
    this.child,
    this.icon,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.captureInheritedThemes = true,
  });

  ///
  final Key? key;

  /// List of menu items to appear in the popup menu.
  final List<T>? items;

  /// The item builder if no List is available.
  final PopupMenuItemBuilder<T>? itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final T? initialValue;

  /// Called when a menu item is selected.
  final PopupMenuItemSelected<T>? onSelected;

  ///todo: Shouldn't these all be final?
  /// Called when the user dismisses the popup menu without selecting an item.
  PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  String? tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  double? elevation;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
  /// this button appears as the trailing element of a list item, it's useful to be able
  /// to set the padding to zero.
  EdgeInsetsGeometry? padding;

  /// If provided, [child] is the widget used for this button
  Widget? child;

  /// If provided, the [icon] is used for this button
  Widget? icon;

  /// The offset applied to the Popup Menu Button.
  ///
  /// When not set, the Popup Menu Button will be positioned directly next to
  /// the button that was used to create it.
  Offset? offset;

  /// Whether this popup menu button is interactive.
  bool? enabled;

  /// If provided, the shape used for the menu.
  ShapeBorder? shape;

  /// If provided, the background color used for the menu.
  Color? color;

  /// Use inherited themes if set to true.
  bool? captureInheritedThemes;

  /// The BuildContext to be used.
  BuildContext? get context => _context;

  set context(BuildContext? context) {
    if (context != null) {
      // Don't assign again. Too dangerous.
      _context ??= context;
    }
  }

  BuildContext? _context;

  /// Produce the menu items for a List of items of type T.
  PopupMenuItemBuilder<T> _onItems(List<T>? menuItems) {
    menuItems ??= items;
    final popupMenuItems = menuItems!
        .map((T? item) =>
            PopupMenuItem<T>(value: item, child: Text(item.toString())))
        .toList();
    return (BuildContext context) => <PopupMenuEntry<T>>[
          ...popupMenuItems,
        ];
  }

  /// override in subclass
  List<PopupMenuItem<T>> get menuItems => [];

  /// override in subclass
  List<PopupMenuEntry<T>> onItemBuilder(BuildContext context) {
    if (menuItems.isEmpty) {
      errorSnackBar();
    }
    return <PopupMenuEntry<T>>[
      ...menuItems,
    ];
  }

  /// override in subclass
  List<T>? onItems() => [];

  /// override in subclass
  T? onInitialValue() => null;

  /// override in subclass
  void onSelection(T value) {}

  /// override in subclass
  void onCancellation() {}

  /// override in subclass
  String? onTooltip() => null;

  /// override in subclass
  double? onElevation() => null;

  /// override in subclass
  EdgeInsetsGeometry? onPadding() => const EdgeInsets.all(8);

  /// override in subclass
  Widget? onChild() => null;

  /// override in subclass
  Widget? onIcon() => null;

  /// override in subclass
  Offset? onOffset() => Offset.zero;

  /// override in subclass
  bool? onEnabled() => true;

  /// override in subclass
  ShapeBorder? onShape() => null;

  /// override in subclass
  Color? onColor() => null;

  /// override in subclass
  bool? onCaptureInheritedThemes() => true;

  /// Provides an error message in a Android's Snack Bar panel.
  void errorSnackBar() {
    final state = ScaffoldMessenger.maybeOf(context!);
    state?.showSnackBar(
      const SnackBar(
        content: Text('Error. No menu options defined.'),
      ),
    );
  }

  ///
  // Returning a widget allows for the Builder() widget below.
  Widget get popupMenuButton => buttonMenu();

  ///
  // Returning a widget allows for the Builder() widget below.
  Widget buttonMenu({
    Key? key,
    List<T>? items,
    PopupMenuItemBuilder<T>? itemBuilder,
    T? initialValue,
    PopupMenuItemSelected<T>? onSelected,
    PopupMenuCanceled? onCanceled,
    String? tooltip,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Widget? child,
    Widget? icon,
    Offset? offset,
    bool? enabled,
    ShapeBorder? shape,
    Color? color,
    bool? captureInheritedThemes,
  }) {
    // So to retrieve the Scaffold object if any.
    return Builder(builder: (context) {
      this.context ??= context;
      items ??= this.items;
      Widget popupMenu = PopupMenuButton<T>(
        key: key ?? this.key,
        itemBuilder: itemBuilder ??
            (items != null && items!.isNotEmpty
                ? _onItems(items)
                : this.itemBuilder) ??
            onItemBuilder,
        initialValue: initialValue ?? this.initialValue ?? onInitialValue(),
        onSelected: onSelected ?? this.onSelected ?? onSelection,
        onCanceled: onCanceled ?? this.onCanceled ?? onCancellation,
        tooltip: tooltip ?? this.tooltip ?? onTooltip(),
        elevation: elevation ?? this.elevation ?? onElevation(),
        padding:
            padding ?? this.padding ?? onPadding() ?? const EdgeInsets.all(8),
        icon: icon ?? this.icon ?? onIcon(),
        offset: offset ?? this.offset ?? onOffset() ?? Offset.zero,
        enabled: enabled ?? this.enabled ?? onEnabled() ?? true,
        shape: shape ?? this.shape ?? onShape(),
        color: color ?? this.color ?? onColor(),
        child: child ?? this.child ?? onChild(),
      );
      // If not running under the MaterialApp widget.
      if (context.widget is! Material &&
          context.findAncestorWidgetOfExactType<Material>() == null) {
        popupMenu = Material(child: popupMenu);
      }
      return popupMenu;
    });
  }
}

///
/// Copy this to supply all the parameters if you want.
///
// class SubclassMenu extends AppPopupMenuButton<String> {
// SubclassMenu(
//     BuildContext context, {
//     Key key,
//     List<T> items,
//     PopupMenuItemBuilder<String> itemBuilder,
//     String initialValue,
//     PopupMenuItemSelected<String> onSelected,
//     PopupMenuCanceled onCanceled,
//     String tooltip,
//     double elevation,
//     EdgeInsetsGeometry padding,
//     Widget child,
//     Widget icon,
//     Offset offset,
//     bool enabled,
//     ShapeBorder shape,
//     Color color,
//     bool captureInheritedThemes,
//   }) : super(
//           context: context,
//           key: key,
//           item: item,
//           itemBuilder: itemBuilder,
//           initialValue: initialValue,
//           onSelected: onSelected,
//           onCanceled: onCanceled,
//           tooltip: tooltip,
//           elevation: elevation,
//           padding: padding,
//           child: child,
//           icon: icon,
//           offset: offset,
//           enabled: enabled,
//           shape: shape,
//           color: color,
//           captureInheritedThemes: captureInheritedThemes,
//         ) {
