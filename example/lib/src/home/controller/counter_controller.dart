import 'package:mvc_application_example/src/controller.dart'
    show App, AppController, State, TemplateController, Widget, WordPairsTimer;

import 'package:mvc_application_example/src/model.dart'
    show CounterModel, State, Widget;

class CounterController extends AppController {
  factory CounterController() => _this ??= CounterController._();
  CounterController._() : super() {
    //
    _model = CounterModel(); // CounterModel(useDouble: true);

    /// Provide the 'timer' controller to the interface.
    wordPairsTimer = WordPairsTimer();
  }
  static CounterController? _this;
  late final CounterModel _model;
  late final WordPairsTimer wordPairsTimer;

  @override
  void initState() {
    super.initState();
    // Add this controller to the State object's lifecycle.
    wordPairsTimer.addState(state);
  }

  // Merely for demonstration purposes. Erase if not using.
  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  void deactivate() {
    super.deactivate();
  }

  // Merely for demonstration purposes. Erase if not using.
  /// The framework calls this method when this [State] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
  }

  /// the 'counter' value.
  String get data => _model.data;

  /// The 'View' is calling setState()
  void onPressed() => _model.onPressed();

  /// Supply the word pair
  Widget get wordPair => wordPairsTimer.wordPair;

  /// Access to the timer
  WordPairsTimer get timer => wordPairsTimer;

  /// The 'Controller' is calling the 'View' to call setState()
//  void onPressed() => setState(() => _model.onPressed());

  /// Retrieve the app's own controller.
  TemplateController get appController =>
      _appController ??= App.vw!.con as TemplateController;
  TemplateController? _appController;
}
