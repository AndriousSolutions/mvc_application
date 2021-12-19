///
import '../../view.dart';

String _location = '========================== controller_test.dart';

Future<void> testTemplateController(WidgetTester tester) async {
  //ignore: avoid_print
  print('====================== Unit Testing Controller ');

  final con = TemplateController();

  final app = con.application;

  expect(app, isInstanceOf<String>(), reason: _location);
  //ignore: avoid_print
  print('con.application: $app $_location');

  con.changeApp('Counter');

  await tester.pumpAndSettle();

  if (!con.counterApp) {
    fail('Failed to switch app. $_location');
  }
}
