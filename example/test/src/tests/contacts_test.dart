///
import '../view.dart';

String _location = '========================== contacts_test.dart';

/// Testing the Contacts app
Future<void> contactsTest(WidgetTester tester) async {
  //
  // Delete the last contact entered
  await _deleteContact(tester);

  // Tap the '+' icon and trigger a frame.
  await tester.tap(find.byIcon(Icons.add));

  await tester.pumpAndSettle();

  // Find a list of word pairs
  Finder finder = find.byType(TextFormField);

  // The text form fields should be available.
  expect(finder, findsWidgets, reason: _location);

  for (var cnt = 0; cnt < 7; cnt++) {
    //
    final field = finder.at(cnt);

    await tester.tap(field);
    await tester.pump();

    await tester.pumpAndSettle();
//  await tester.showKeyboard(field);
    String text = '';
    switch (cnt) {
      case 0:
        text = 'Greg';
        break;
      case 1:
        text = '';
        break;
      case 2:
        text = 'Perry';
        break;
      case 3:
        text = '123 456-7890';
        break;
      case 4:
        text = 'greg.perry@somewhere.com';
        break;
      case 5:
        text = 'Andrious Solutions Ltd.';
        break;
      case 6:
        text = 'Founder';
        break;
    }
    await tester.enterText(field, text);
  }

  finder = find.widgetWithIcon(TextButton, Icons.save);

  expect(finder, findsOneWidget, reason: _location);

  await tester.tap(finder);
  await tester.pump();

  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
}

/// Delete a contact if any
Future<void> _deleteContact(WidgetTester tester) async {
  //
  final con = ContactsController();

  // If there are no contacts
  if (con.items == null || con.items!.isEmpty) {
    return;
  }

  Finder finder;

  if (App.useMaterial) {
    //
    finder = find.byType(ListTile, skipOffstage: false);

    expect(finder, findsWidgets, reason: _location);

    await tester.tap(finder.first);
    await tester.pump();
  } else {
    //
    finder = find.byWidgetPredicate(
        (Widget widget) => widget is GestureDetector && widget.child is Row,
        description: 'a CupertinoListTile widget',
        skipOffstage: false);

    expect(finder, findsWidgets, reason: _location);

    // Retrieve the widget
    final tile = tester.firstWidget<GestureDetector>(finder);

    tile.onTap!();
  }
  await tester.pumpAndSettle();

  final deleteButton = find.widgetWithIcon(
      App.useMaterial ? TextButton : IconButton, Icons.delete,
      skipOffstage: false);

  expect(deleteButton, findsOneWidget, reason: _location);

  await tester.tap(deleteButton);
  await tester.pump();
  await tester.pumpAndSettle();

  // Find the appropriate button even if translated.
  final button = find.widgetWithText(
      App.useMaterial ? TextButton : CupertinoDialogAction, 'OK');
  expect(button, findsOneWidget, reason: _location);
  await tester.tap(button);
  await tester.pump();
  await tester.pumpAndSettle();
}
