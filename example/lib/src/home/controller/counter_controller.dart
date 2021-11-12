import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/model.dart';

// You can see 'at a glance' this Controller also 'talks to' the interface (View).
import 'package:mvc_application_example/src/view.dart';

class CounterController extends AppController {
  factory CounterController() => _this ??= CounterController._();
  CounterController._() : super() {
    //
    _model = CounterModel();
  }
  static CounterController? _this;

  late final CounterModel _model;

  String get data => _model.data;

  /// The 'View' is calling setState()
  void onPressed() => _model.onPressed();

  /// Retrieve the app's own controller.
  TemplateController get appController =>
      _appController ??= App.vw!.con as TemplateController;
  TemplateController? _appController;

  /// Supply the app's popupmenu
  Widget popupMenu({
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
  }) =>
      TemplateController().popupMenu(
        key: key,
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
        offset: offset,
        enabled: enabled,
        shape: shape,
        color: color,
        captureInheritedThemes: captureInheritedThemes,
      );
}
