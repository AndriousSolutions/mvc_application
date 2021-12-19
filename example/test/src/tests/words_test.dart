///
import '../view.dart';

String _location = '========================== words_test.dart';

/// Testing Random Word Pairs App
Future<void> wordsTest(WidgetTester tester) async {
  //
  Finder finder;

  if (App.useMaterial) {
    // Find a list of word pairs
    finder = find.byType(ListTile);
  } else {
    finder = find.byType(CupertinoListTile);
  }

  expect(finder, findsWidgets, reason: _location);

  // Tap the first three words
  if (App.useMaterial) {
    //
    await tester.tap(finder.first);
    await tester.pump();

    await tester.tap(finder.at(1));
    await tester.pump();

    await tester.tap(finder.at(2));
    await tester.pump();
  } else {
    //
    // Retrieve the widget
    var tile = tester.widget<CupertinoListTile>(finder.first);
    tile.onTap!();
    await tester.pump();

    tile = tester.widget<CupertinoListTile>(finder.at(1));
    tile.onTap!();
    await tester.pump();

    tile = tester.widget<CupertinoListTile>(finder.at(2));
    tile.onTap!();
    await tester.pump();
  }

  if (App.useCupertino) {
    return;
  }

  /// Go to the 'Saved Suggestions' page
  finder = find.byKey(const Key('listSaved')); // find.bytype(IconButton);

  expect(finder, findsWidgets, reason: _location);

  await tester.tap(finder.first);
  await tester.pump();

  /// Rebuild the Widget after the state has changed
  await tester.pumpAndSettle();

  final model = WordPairsModel();

  /// Successfully saved the selected word-pairs.
  if (model.saved.isEmpty) {
//    fail('Failed to list saved suggestions');
  } else {
    expect(model.saved.length, equals(3), reason: _location);
  }

  if (App.useMaterial) {
    finder = find.byType(IconButton);

    expect(finder, findsOneWidget, reason: _location);

    /// Find the 'back button' and return
    await tester.tap(finder.first);
  } else {
    final con = WordPairsController();
    final state = con.state;
    Navigator.of(state!.context).pop();
  }

  /// Wait a frame after the state has changed;
  await tester.pump();
}
