import 'package:flutter_test/flutter_test.dart';
import 'package:mvc_application/view.dart' show AppMVC, Key;

// ignore: avoid_relative_lib_imports
import '../example/lib/src/controller.dart' show ControllerMVC;

// ignore: avoid_relative_lib_imports
import '../example/lib/src/view.dart'
    show
        AppMVC,
        BuildContext,
        Key,
        MaterialApp,
        MyApp,
        State,
        StateMVC,
        StatefulWidget,
        UniqueKey,
        Widget;

void main() {
  final test = _TestApp()
    ..run(MyApp(
      key: _TestApp.appKey,
      rootKey: _TestApp.rootKey,
    ));
}

class _TestApp {
  static final Key appKey = UniqueKey();
  static final Key rootKey = UniqueKey();

  void run(AppMVC app) {
    testWidgets('Test MVC Application', (WidgetTester tester) async {
      // Tells the tester to build a UI based on the widget tree passed to it
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();

      /// You can directly access the 'internal workings' of the app!
      Widget widget = tester.widget(find.byKey(appKey));

      expect(widget, isInstanceOf<AppMVC>());

      final AppMVC appObj = widget;

      /// Reference to the Controller.
      final ControllerMVC con = appObj.controller;

      if (con != null) {
        expect(con, isInstanceOf<ControllerMVC>());

        /// Reference to the StateMVC.
        final StateMVC _sv = con.stateMVC;

        expect(_sv, isInstanceOf<StateMVC<StatefulWidget>>());

        /// The State object.
        final State _state = con.stateMVC;

        expect(_state, isInstanceOf<State<StatefulWidget>>());

        /// Controller's unique identifier.
        final id = con.keyId;

        expect(id, isInstanceOf<String>());

        /// The StateView's unique identifier.
        final svId = _sv.keyId;

        expect(svId, isInstanceOf<String>());

        /// Current context.
        final context2 = _sv.context;

        expect(context2, isInstanceOf<BuildContext>());

        /// Is the widget mounted?
        final mounted2 = _sv.mounted;

        expect(mounted2, isInstanceOf<bool>());

        /// The StatefulWidget.
        final widget2 = _sv.widget;

        expect(widget2, isInstanceOf<StatefulWidget>());
      }

      /// You can directly access the 'internal workings' of the app!
      widget = tester.widget(find.byKey(rootKey));

      expect(widget, isInstanceOf<MaterialApp>());

//      final MaterialApp root = widget;
    });
  }
}
