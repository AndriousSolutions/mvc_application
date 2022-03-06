import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/model.dart';

// You can see 'at a glance' this Controller also 'talks to' the interface (View).
import 'package:mvc_application_example/src/view.dart';

class WordPairsController extends ControllerMVC {
  factory WordPairsController([StateMVC? state]) =>
      _this ??= WordPairsController._(state);
  WordPairsController._(StateMVC? state)
      : timer = WordPairsTimer(),
        model = WordPairsModel(),
        super(state);
  static WordPairsController? _this;
  final WordPairsTimer timer;
  final WordPairsModel model;

  @override
  void initState() {
    super.initState();
    model.addState(state);
  }

  /// Start up the timer.
  void initTimer() => timer.initTimer();

  /// Cancel the timer
  void cancelTimer() => timer.timer.cancel();

  Widget get wordPair => timer.wordPair;

  void build(int i) => model.build(i);

  String get data => model.data;

  Widget get trailing => model.trailing;

  void onTap(int i) => model.onTap(i);

  Iterable<Widget> tiles() => model.tiles();
}
