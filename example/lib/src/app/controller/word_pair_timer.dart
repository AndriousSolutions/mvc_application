import 'dart:async';

import 'package:mvc_application_example/src/model.dart';

import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application/controller.dart';

import 'package:english_words/english_words.dart';

class WordPairsTimer extends ControllerMVC {
  /// Only one instance of the class is necessary and desired.
  factory WordPairsTimer({
    int? seconds,
    Duration? duration,
    void Function()? callback,
    int? count,
    StateMVC? state,
  }) =>
      _this ??= WordPairsTimer._(seconds, duration, callback, count, state);

  WordPairsTimer._(
      this.seconds, this.duration, this.callback, this.count, StateMVC? state)
      : model = WordPairsModel(),
        super(state);

  static WordPairsTimer? _this;
  final int? seconds;
  final Duration? duration;
  final void Function()? callback;
  final int? count;
  final WordPairsModel model;

  Timer? timer;

  /// Retrieve a particular State object of a specific type
  /// that this Controller is 'attached' to.

  TemplateView? get appStateObject =>
      _appStateObject ??= rootState as TemplateView;
  TemplateView? _appStateObject;

  final suggestions = <WordPair>[];
  int index = 0;

  @override
  void initState() {
    super.initState();

    /// Initialize the timer.
    initTimer();

    model.addState(state);
  }

  @override
  void deactivate() {
    cancelTimer();
  }

  @override
  void activate() {
    initTimer();
  }

  @override
  void dispose() {
    _appStateObject = null;
    cancelTimer();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    cancelTimer();
    return super.didPopRoute();
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //
    if (state == AppLifecycleState.resumed) {
      /// Create the Timer again.
      initTimer();
    } else if (state == AppLifecycleState.paused) {
      /// Passing these possible values:
      /// AppLifecycleState.paused (may enter the suspending state at any time)
      /// AppLifecycleState.inactive (may be paused at any time)
      /// AppLifecycleState.suspending (Android only)
      cancelTimer();
    }
  }

  /// If the value of the object, obj, changes, this builder() is called again
  /// This allows spontaneous rebuilds here and there and not the whole screen.
  Widget get wordPair => SetState(builder: (context, obj) {
        Widget widget;
        if (obj is String) {
          widget = Text(
            obj,
            style: TextStyle(
              color: Colors.red,
              fontSize: Theme.of(context).textTheme.headline4!.fontSize,
            ),
          );
        } else {
          widget = const SizedBox(height: 5);
        }
        return widget;
      });

  /// Alternate approach. See class _WordPair
//  Widget get wordPair => _WordPair(this);
  String _wordPair = '';

  void _getWordPair() {
    //
    try {
      final WordPair twoWords;

      if (model.saved.isNotEmpty) {
        twoWords = model.getWordPair();
      } else {
        twoWords = getWordPair();
      }

      /// Alternate approach uses inheritWidget() and setStatesInherited() functions.
      _wordPair = twoWords.asString;

      /// Option 1:  Simply rebuild the InheritedWidget
      /// This calls the framework's InheritedWidget to rebuild
//      appStateObject?.buildInherited();

      /// Option 2: Change dataObject will rebuild the InheritedWidget
      /// Changing the 'dataObject' will call the SetState class implemented above
      /// and only that widget.
      appStateObject?.dataObject = _wordPair;

      /// Option 3: Also changes dataObject and rebuilds the InheritedWidget
//      appStateObject?.inheritedNeedsBuild(_wordPair);
    } catch (ex) {
      // Record the error.
      getError(ex);

      /// Stop the timer.
      /// Something is not working. Don't have the timer repeat it over and over.
      cancelTimer();

      // Rethrow the error so to get processed by the App's error handler.
      rethrow;
    }
  }

  /// Supply a set of word pairs
  /// Generate a certain number of word pairs
  /// and when those are used, generate another set.
  WordPair getWordPair() {
    index++;
    if (index >= suggestions.length) {
      index = 0;
      suggestions.clear();
      suggestions.addAll(generateWordPairs().take(count ?? 10));
    }
    return suggestions[index];
  }

  bool _initTimer = false;

  /// Cancel the timer
  void cancelTimer() {
    _initTimer = false;
    timer?.cancel();
  }

  /// Create a Timer to run periodically.
  void initTimer() {
    // Initialize once.
    if (_initTimer) {
      return;
    }

    _initTimer = true;

    Duration _duration;
    void Function() _callback;

    /// Supply a 'default' duration if one is not provided.
    if (duration == null) {
      int _seconds;
      if (seconds == null) {
        _seconds = 5;
      } else {
        _seconds = seconds!;
      }
      _duration = Duration(seconds: _seconds);
    } else {
      _duration = duration!;
    }

    /// Supply a 'default' callback function
    if (callback == null) {
      _callback = _getWordPair;
    } else {
      _callback = callback!;
    }

    timer = Timer.periodic(
      _duration,
      (timer) => _callback(),
    );
  }
}

/// Alternate approach to spontaneous rebuilds using the framework's InheritedWidget.
/// This approach uses inheritWidget() and setStatesInherited() functions.
/// This class is assigned to the getter, wordPair.
class _WordPair extends StatelessWidget {
  const _WordPair(this.con, {Key? key}) : super(key: key);
  final WordPairsTimer con;
  @override
  Widget build(BuildContext context) {
    /// This is where the magic happens.
    /// This Widget becomes a dependent of an InheritedWidget deep in the framework.
    con.appStateObject?.dependOnInheritedWidget(context);

    // String data;
    //
    // if (con.appStateObject?.dataObject is String) {
    //   data = con.appStateObject?.dataObject as String;
    // } else {
    //   data = con._wordPair;
    // }

    return Text(
      con._wordPair, //data,
      style: TextStyle(
        color: Colors.red,
        fontSize: Theme.of(context).textTheme.headline4!.fontSize,
      ),
    );
  }
}
