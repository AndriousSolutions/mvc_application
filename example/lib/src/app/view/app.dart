import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/view.dart';

/// App
class TemplateApp extends AppStatefulWidget {
  TemplateApp({Key? key}) : super(key: key);

  // This is the 'View' of the application.
  @override
  AppState createAppState() => TemplateView();
}

// This is the 'View' of the application. The 'look and feel' of the app.
class TemplateView extends AppState {
  TemplateView()
      : super(
          con: TemplateController(),
          controllers: [ContactsController()],
          inTitle: () => 'Demo App'.tr,
          debugShowCheckedModeBanner: false,
          switchUI: Prefs.getBool('switchUI'),
          locale: AppTrs.textLocale,
          supportedLocales: AppTrs.supportedLocales,
          localizationsDelegates: [
            AppTrs.delegate!,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        );
  @override
  Widget onHome() => (con as TemplateController).onHome();
}
