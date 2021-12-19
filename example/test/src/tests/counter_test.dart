///
import '../view.dart';

String _location = '========================== counter_test.dart';

/// Testing the counter app
Future<void> counterTest(WidgetTester tester) async {
  // Retrieve the current count.
  String start = CounterController().data;
  // Verify that our counter starts at 0.
  expect(find.text(start), findsOneWidget, reason: _location);
  expect(find.text('1'), findsNothing, reason: _location);

  // 9 counts
  for (int cnt = 1; cnt <= 9; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  }

  final end = int.parse(start) + 9;
  start = end.toString();

  // Verify that our counter has incremented.
  expect(find.text('0'), findsNothing, reason: _location);
  expect(find.text(start), findsOneWidget, reason: _location);
}
