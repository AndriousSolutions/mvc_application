import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/view.dart';

/// App
class TemplateApp extends AppMVC {
  TemplateApp({Key? key}) : super(key: key, con: TemplateController());
  // This is the 'View' of the application.
  @override
  AppState createState() => TemplateView();
}

// This is the 'View' of the application. The 'look and feel' of the app.
class TemplateView extends AppState {
  TemplateView()
      : super(
          con: TemplateController(),
          controllers: [ContactsController(), WordPairsTimer(seconds: 2)],
          inTitle: () => I10n.s('Demo App'),
          debugShowCheckedModeBanner: false,
          switchUI: Prefs.getBool('switchUI'),
          supportedLocales: I10n.supportedLocales,
          localizationsDelegates: [
            I10nDelegate(),
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        );
  @override
  Widget onHome() => (con as TemplateController).onHome();
}
