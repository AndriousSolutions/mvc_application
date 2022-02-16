import 'package:flutter/material.dart' show Key, Scrollable, SimpleDialogOption;

import 'package:flutter_test/flutter_test.dart';

import 'open_menu.dart';

String _location = '========================== locale_menu.dart';

/// Open the Locale menu
Future<void> openLocaleMenu(WidgetTester tester) async {
  /// Open the popupmenu
  await openPopupMenu(tester);

  /// Open the Locale window
  final locale = find.byKey(const Key('localeMenuItem'));
  expect(locale, findsOneWidget, reason: _location);
  await tester.tap(locale);
  await tester.pumpAndSettle();

  /// Select a language
  await selectLanguage(tester);

  /// Close window
  final button = find.widgetWithText(SimpleDialogOption, 'Cancel');
  expect(button, findsOneWidget, reason: _location);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> selectLanguage(WidgetTester tester) async {
  //
  final listFinder = find.byType(Scrollable, skipOffstage: false);

  expect(listFinder, findsWidgets, reason: _location);

  // Scroll until the item to be found appears.
  await tester.scrollUntilVisible(
    find.text('fr-FR'),
    500.0,
    scrollable: listFinder.last,
  );

  await tester.tap(listFinder.last);
  await tester.pump();
  await tester.pumpAndSettle();
}
