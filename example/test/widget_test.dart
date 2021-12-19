///

import 'src/view.dart';

void main() {
  /// Define a test. The TestWidgets function also provides a WidgetTester
  /// to work with. The WidgetTester allows you to build and interact
  /// with widgets in the test environment.
  testWidgets('app_template testing', (WidgetTester tester) async {
    //
    await tester.pumpWidget(TemplateApp());

    /// Flutter won’t automatically rebuild your widget in the test environment.
    /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.

    /// pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    final con = TemplateController();

//    for (var interface = 1; interface <= 2; interface++) {
    //
    int cnt = 1;

    while (cnt <= 3) {
      switch (con.application) {
        case 'Counter':

          /// Counter app testing
          await counterTest(tester);
          break;
        case 'Word Pairs':

          /// Random Word Pairs app
          await wordsTest(tester);
          break;
        case 'Contacts':

          /// Contacts app
          await contactsTest(tester);
          break;
      }

      /// Switch the app programmatically.
      // con.changeApp();
      /// Switch the app through the popupmenu
      await openApplicationMenu(tester);

      /// Wait for the transition in the Interface
      await tester.pumpAndSettle();

      cnt++;
    }

    /// Open the Locale window
    await openLocaleMenu(tester);

    /// Open About menu
    await openAboutMenu(tester);

    /// Switch the Interface
    await openInterfaceMenu(tester);
//    }

    /// Unit testing does not involve integration or widget testing.

    /// WordPairs App Model Unit Testing
    await wordPairsModelTest(tester);

    /// Unit testing the App's controller object
    await testTemplateController(tester);

    reportTestErrors();
  });
}
