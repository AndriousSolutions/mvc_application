import 'dart:async';

import 'package:mvc_application/src/controller/get_utils/get_utils.dart';

///
extension GetNumUtils on num {
  /// True if this number is lower than num
  bool isLowerThan(num b) => GetUtils.isLowerThan(this, b);

  /// True if this number is greater than num
  bool isGreaterThan(num b) => GetUtils.isGreaterThan(this, b);

  /// True if this number is equal to num
  bool isEqual(num b) => GetUtils.isEqual(this, b);

  /// Utility to delay some callback (or code execution).
  /// to stop it.
  ///
  /// Sample:
  /// ```
  /// void main() async {
  ///   print('+ wait for 2 seconds');
  ///   await 2.delay();
  ///   print('- 2 seconds completed');
  ///   print('+ callback in 1.2sec');
  ///   1.delay(() => print('- 1.2sec callback called'));
  ///   print('currently running callback 1.2sec');
  /// }
  ///```
  Future<void> delay([FutureOr<void> Function()? callback]) async =>
      Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );

  /// Easy way to make Durations from numbers.
  ///
  /// Sample:
  /// ```
  /// print(1.seconds + 200.milliseconds);
  /// print(1.hours + 30.minutes);
  /// print(1.5.hours);
  ///```
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  /// This number in seconds.
  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  /// This number in minutes.
  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  /// This number in hours.
  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  /// This number in days.
  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}
