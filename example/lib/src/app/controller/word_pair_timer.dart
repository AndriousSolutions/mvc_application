import 'dart:async';

import 'package:mvc_application_example/src/model.dart';

import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application/controller.dart';

import 'package:english_words/english_words.dart';

class WordPairsTimer extends ControllerMVC {
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

  late Timer timer;

  /// Retrieve a particular State object of a specific type
  /// that this Controller is 'attached' to.

  TemplateView? get appStateObject =>
      _appStateObject ??= ofState<TemplateView>();
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
    timer.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _appStateObject = null;
    timer.cancel();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    timer.cancel();
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
      timer.cancel();
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

      /// Changing the 'dataObject' will call the SetState class implemented above
      /// and only that widget. Only it will be rebuilt; not the whole widget tree.
      appStateObject?.dataObject = twoWords.asString;

      /// Alternate approach uses inheritWidget() and setStatesInherited() funtions.
      _wordPair = twoWords.asString;

      /// This calls the framework's InheritedWidget to rebuild
      // appStateObject?.setStatesInherited();
      // appStateObject?.inheritedNeedsBuild();

//      appStateObject?.inheritedNeedsBuild(_wordPair);
    } catch (ex) {
      // Record the error.
      getError(ex);

      /// Stop the timer.
      /// Something is not working. Don't have the timer repeat it over and over.
      timer.cancel();

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

  /// Create a Timer to run periodically.
  void initTimer() {
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

    timer = Timer.periodic(_duration, (timer) => _callback());
  }

  /// Cancel the timer
  void cancelTimer() => timer.cancel();
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
    con.appStateObject?.inheritWidget(context);

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
