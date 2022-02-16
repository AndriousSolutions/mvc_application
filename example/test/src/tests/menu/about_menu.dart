import '../../view.dart';

String _location = '========================== about_menu.dart';

/// Open the About menu
Future<void> openAboutMenu(WidgetTester tester) async {
  /// Open popup menu
  await openPopupMenu(tester);

  /// Open the About window
  final about = find.byKey(const Key('aboutMenuItem'));
  expect(about, findsOneWidget, reason: _location);
  await tester.tap(about);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();

  /// Close window
  // Find the appropriate button even if translated.
  final button = find.widgetWithText(TextButton, L10n.s('CLOSE'));
  expect(button, findsOneWidget, reason: _location);
  await tester.tap(button);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
}
