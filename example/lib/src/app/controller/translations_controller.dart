import 'package:mvc_application_example/src/model.dart';

import 'package:mvc_application_example/src/view.dart';

//ignore: non_constant_identifier_names
final AppTrs = AppTranslations();

class AppTranslations extends L10nTranslations {
  factory AppTranslations() => _this ??= AppTranslations._();
  AppTranslations._();
  static AppTranslations? _this;

  /// The text's original Locale
  @override
  Locale get textLocale => const Locale('en', 'US');

  /// The app's translations
  @override
  Map<Locale, Map<String, String>> get l10nMap => {
        const Locale('zh', 'CN'): zhCN,
        const Locale('fr', 'FR'): frFR,
        const Locale('de', 'DE'): deDE,
        const Locale('he', 'IL'): heIL,
        const Locale('ru', 'RU'): ruRU,
        const Locale('es', 'AR'): esAR,
      };
}
