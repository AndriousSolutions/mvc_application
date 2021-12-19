import 'package:mvc_application_example/src/model.dart';

import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application_example/src/controller.dart';

class PopMenu extends AppPopupMenu<String> {
  //
  PopMenu({
    Key? key,
    List<String>? items,
    PopupMenuItemBuilder<String>? itemBuilder,
    String? initialValue,
    PopupMenuItemSelected<String>? onSelected,
    PopupMenuCanceled? onCanceled,
    String? tooltip,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Widget? child,
    Widget? icon,
    Offset? offset,
    bool? enabled,
    ShapeBorder? shape,
    Color? color,
    bool? captureInheritedThemes,
  })  : _con = TemplateController(),
        super(
          key: key ?? const Key('appMenuButton'),
          items: items,
          itemBuilder: itemBuilder,
          initialValue: initialValue,
          onSelected: onSelected,
          onCanceled: onCanceled,
          tooltip: tooltip,
          elevation: elevation,
          padding: padding,
          child: child,
          icon: icon,
          offset: offset ?? const Offset(0, 45),
          enabled: enabled,
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: color,
          // false so to prevent the error,
          // "Looking up a deactivated widget's ancestor is unsafe."
          captureInheritedThemes: captureInheritedThemes ?? false,
        );

  final TemplateController _con;

  // Supply what the interface
  String get application => _con.application;

  String get interface => App.useMaterial ? 'Material' : 'Cupertino';

  @override
  List<PopupMenuItem<String>> get menuItems => [
        PopupMenuItem(
          key: const Key('interfaceMenuItem'),
          value: 'interface',
          child: Text('${I10n.s('Interface:')} $interface'),
        ),
        PopupMenuItem(
          key: const Key('applicationMenuItem'),
          value: 'application',
          child: Text('${I10n.s('Application:')} $application'),
        ),
        PopupMenuItem(
          key: const Key('localeMenuItem'),
          value: 'locale',
          child: Text('${I10n.s('Locale:')} ${App.locale!.toLanguageTag()}'),
        ),
        if (App.useMaterial)
          PopupMenuItem(
            key: const Key('colorMenuItem'),
            value: 'color',
            child: I10n.t('Colour Theme'),
          ),
        PopupMenuItem(
          key: const Key('aboutMenuItem'),
          value: 'about',
          child: I10n.t('About'),
        ),
      ];

  @override
  Future<void> onSelection(String value) async {
    final appContext = App.context!;
    switch (value) {
      case 'interface':
        _con.changeUI();
        break;
      case 'application':
        _con.changeApp();
        break;
      case 'locale':
        final locales = I10n.supportedLocales!;

        final initialItem = locales.indexOf(App.locale!);

        final spinner = ISOSpinner(
            initialItem: initialItem,
            supportedLocales: locales,
            onSelectedItemChanged: (int index) async {
              // Retrieve the available locales.
              final locale = I10n.getLocale(index);
              if (locale != null) {
                I10n.onSelectedItemChanged(index);
                App.locale = locale;
                App.refresh();
              }
            });

        await DialogBox(
          title: I10n.s('Current Language'),
          body: [spinner],
          press01: () {
            spinner.onSelectedItemChanged(initialItem);
          },
          press02: () {},
          switchButtons: Settings.getLeftHanded(),
        ).show();

        // If the current app is the 'counter' app
        if (_con.counterApp) {
          // Has to be initialized again for some reason??
          _con.initTimer();
        }

        break;
      case 'color':
        // Set the current colour.
        ColorPicker.color = App.themeData!.primaryColor;

        await ColorPicker.showColorPicker(
            context: appContext,
            onColorChange: _onColorChange,
            onChange: _onChange,
            shrinkWrap: true);
        break;
      case 'about':
        showAboutDialog(
          context: appContext,
          applicationName: App.vw?.title ?? '',
          applicationVersion:
              'version: ${App.version} build: ${App.buildNumber}',
        );
        break;
      default:
    }
  }

  void _onColorChange(Color value) {
    /// Implement to take in a color change.
  }

  /// Of course, the controller is to response to such user events.
  void _onChange([ColorSwatch<int?>? value]) => _con.onColorPicker(value);
}
