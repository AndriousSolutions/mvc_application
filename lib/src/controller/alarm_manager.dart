///
/// Copyright (C) 2020 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  11 Mar 2020
///
///

/// AlarmManager
///
/// Works with the Flutter plugin, android_alarm_manager,
/// that accesses the Android AlarmManager service running Dart code
/// in the background when alarms fire.
///
/// If `alarmClock` is passed as `true`, the timer will be created with
/// Android's `AlarmManagerCompat.setAlarmClock`.
///
/// If `allowWhileIdle` is passed as `true`, the timer will be created with
/// Android's `AlarmManagerCompat.setExactAndAllowWhileIdle` or
/// `AlarmManagerCompat.setAndAllowWhileIdle`.
///
/// If `exact` is passed as `true`, the timer will be created with Android's
/// `AlarmManagerCompat.setExact`. When `exact` is `false` (the default), the
/// timer will be created with `AlarmManager.set`.
///
/// If `wakeup` is passed as `true`, the device will be woken up when the
/// alarm fires. If `wakeup` is false (the default), the device will not be
/// woken up to service the alarm.
///
/// If `rescheduleOnReboot` is passed as `true`, the alarm will be persisted
/// across reboots. If `rescheduleOnReboot` is false (the default), the alarm
/// will not be rescheduled after a reboot and will not be executed.
///

import 'dart:async' show Future;

import 'dart:ui' show CallbackHandle, PluginUtilities;

import 'package:android_alarm_manager/android_alarm_manager.dart';

class AlarmManager {
  static Future<bool> init({
    bool alarmClock = false,
    bool allowWhileIdle = false,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
    DateTime startAt,
  }) async {
    // Don't continue if already called.
    if (_init) return _init;
    _init = true;
    // Record the failure if any.
    bool init = await AndroidAlarmManager.initialize();
    if (!init) getError(Exception("AndroidAlarmManager not initialize!"));

    if (alarmClock != null) _alarmClock = alarmClock;
    if (allowWhileIdle != null) _allowWhileIdle = allowWhileIdle;
    if (exact != null) _exact = exact;
    if (wakeup != null) _wakeup = wakeup;
    if (rescheduleOnReboot != null) _rescheduleOnReboot = rescheduleOnReboot;
    if (startAt != null) _startAt = startAt;

    return _init;
  }

  static bool _init = false;
  static bool _alarmClock = false;
  static bool _allowWhileIdle = false;
  static bool _exact = false;
  static bool _wakeup = false;
  static bool _rescheduleOnReboot = false;
  static DateTime _startAt;

  static bool get hasError => _error != null;
  static bool get inError => _error != null;
  static Object _error;

  /// Records the `error` when it occurs.
  ///
  static Exception getError([Object error]) {
    Exception ex = _error;
    if (error == null) {
      _error = null;
    } else {
      if (error is! Exception) error = Exception(error.toString());
      _error = error;
    }
    if (ex == null) ex = error;
    return ex;
  }

  /// Schedules a one-shot timer to run `callback` after time `delay`.
  ///
  /// The `callback` will run whether or not the main application is running or
  /// in the foreground. It will run in the Isolate owned by the
  /// AndroidAlarmManager service.
  ///
  /// `callback` must be either a top-level function or a static method from a
  /// class.
  ///
  /// `callback` can be `Function()` or `Function(int)`
  ///
  /// The timer is uniquely identified by `id`. Calling this function again
  /// with the same `id` will cancel and replace the existing timer.
  ///
  /// `id` will passed to `callback` if it is of type `Function(int)`
  ///
  /// If `alarmClock` is passed as `true`, the timer will be created with
  /// Android's `AlarmManagerCompat.setAlarmClock`.
  ///
  /// If `allowWhileIdle` is passed as `true`, the timer will be created with
  /// Android's `AlarmManagerCompat.setExactAndAllowWhileIdle` or
  /// `AlarmManagerCompat.setAndAllowWhileIdle`.
  ///
  /// If `exact` is passed as `true`, the timer will be created with Android's
  /// `AlarmManagerCompat.setExact`. When `exact` is `false` (the default), the
  /// timer will be created with `AlarmManager.set`.
  ///
  /// If `wakeup` is passed as `true`, the device will be woken up when the
  /// alarm fires. If `wakeup` is false (the default), the device will not be
  /// woken up to service the alarm.
  ///
  /// If `rescheduleOnReboot` is passed as `true`, the alarm will be persisted
  /// across reboots. If `rescheduleOnReboot` is false (the default), the alarm
  /// will not be rescheduled after a reboot and will not be executed.
  ///
  /// Returns a [Future] that resolves to `true` on success and `false` on
  /// failure.
  static Future<bool> oneShot(
    Duration delay,
    int id,
    Function callback, {
    bool alarmClock,
    bool allowWhileIdle,
    bool exact,
    bool wakeup,
    bool rescheduleOnReboot,
  }) async {
    //
    bool oneShot = false;

    if (delay == null || delay.inSeconds <= 0) {
      getError("oneShotAt(): `delay` is null or less than or zero.");
      return oneShot;
    }

    if (id == null || id <= 0) {
      getError("oneShotAt(): `id` is null or less than or zero.");
      return oneShot;
    }

    CallbackHandle handle = PluginUtilities.getCallbackHandle(callback);
    assert(handle != null,
        "oneShotAt(): `callback` is not a top-level or static function");
    if (handle == null) {
      getError("oneShotAt(): `callback` is not a top-level or static function");
      return oneShot;
    }

    oneShot = await AlarmManager.init(
      alarmClock: alarmClock,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      wakeup: wakeup,
      rescheduleOnReboot: rescheduleOnReboot,
    );

    if (!oneShot) return oneShot;

    try {
      oneShot = await AndroidAlarmManager.oneShot(
        delay,
        id,
        callback,
        alarmClock: alarmClock ?? _alarmClock,
        allowWhileIdle: allowWhileIdle ?? _allowWhileIdle,
        exact: exact ?? _exact,
        wakeup: wakeup ?? _wakeup,
        rescheduleOnReboot: rescheduleOnReboot ?? _rescheduleOnReboot,
      );
    } catch (ex) {
      oneShot = false;
      getError(ex);
    }
    return oneShot;
  }

  /// Schedules a one-shot timer to run `callback` at `time`.
  ///
  /// The `callback` will run whether or not the main application is running or
  /// in the foreground. It will run in the Isolate owned by the
  /// AndroidAlarmManager service.
  ///
  /// `callback` must be either a top-level function or a static method from a
  /// class.
  ///
  /// `callback` can be `Function()` or `Function(int)`
  ///
  /// The timer is uniquely identified by `id`. Calling this function again
  /// with the same `id` will cancel and replace the existing timer.
  ///
  /// `id` will passed to `callback` if it is of type `Function(int)`
  ///
  /// If `alarmClock` is passed as `true`, the timer will be created with
  /// Android's `AlarmManagerCompat.setAlarmClock`.
  ///
  /// If `allowWhileIdle` is passed as `true`, the timer will be created with
  /// Android's `AlarmManagerCompat.setExactAndAllowWhileIdle` or
  /// `AlarmManagerCompat.setAndAllowWhileIdle`.
  ///
  /// If `exact` is passed as `true`, the timer will be created with Android's
  /// `AlarmManagerCompat.setExact`. When `exact` is `false` (the default), the
  /// timer will be created with `AlarmManager.set`.
  ///
  /// If `wakeup` is passed as `true`, the device will be woken up when the
  /// alarm fires. If `wakeup` is false (the default), the device will not be
  /// woken up to service the alarm.
  ///
  /// If `rescheduleOnReboot` is passed as `true`, the alarm will be persisted
  /// across reboots. If `rescheduleOnReboot` is false (the default), the alarm
  /// will not be rescheduled after a reboot and will not be executed.
  ///
  /// Returns a [Future] that resolves to `true` on success and `false` on
  /// failure.
  static Future<bool> oneShotAt(
    DateTime datetime,
    int id,
    Function callback, {
    bool alarmClock,
    bool allowWhileIdle,
    bool exact,
    bool wakeup,
    bool rescheduleOnReboot,
  }) async {
    //
    bool oneShotAt = false;

    if (datetime == null) return oneShotAt;

    DateTime time = datetime.toLocal();

    if (time == null || time.hour < 0) {
      getError("oneShotAt(): `datetime` is less than or zero.");
      return oneShotAt;
    }

    assert(id != null && id > 0);
    if (id == null || id <= 0) {
      getError("oneShotAt(): `id` is null or less than or zero.");
      return oneShotAt;
    }

    CallbackHandle handle = PluginUtilities.getCallbackHandle(callback);
    assert(handle != null,
        "oneShotAt(): `callback` is not a top-level or static function");
    if (handle == null) {
      getError("oneShotAt(): `callback` is not a top-level or static function");
      return oneShotAt;
    }

    oneShotAt = await AlarmManager.init(
      alarmClock: alarmClock,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      wakeup: wakeup,
      rescheduleOnReboot: rescheduleOnReboot,
    );

    if (!oneShotAt) return oneShotAt;

    try {
      oneShotAt = await AndroidAlarmManager.oneShotAt(
        time,
        id,
        callback,
        alarmClock: alarmClock ?? _alarmClock,
        allowWhileIdle: allowWhileIdle ?? _allowWhileIdle,
        exact: exact ?? _exact,
        wakeup: wakeup ?? _wakeup,
        rescheduleOnReboot: rescheduleOnReboot ?? _rescheduleOnReboot,
      );
    } catch (ex) {
      oneShotAt = false;
      getError(ex);
    }
    return oneShotAt;
  }

  /// Schedules a repeating timer to run `callback` with period `duration`.
  ///
  /// The `callback` will run whether or not the main application is running or
  /// in the foreground. It will run in the Isolate owned by the
  /// AndroidAlarmManager service.
  ///
  /// `callback` must be either a top-level function or a static method from a
  /// class.
  ///
  /// `callback` can be `Function()` or `Function(int)`
  ///
  /// The repeating timer is uniquely identified by `id`. Calling this function
  /// again with the same `id` will cancel and replace the existing timer.
  ///
  /// `id` will passed to `callback` if it is of type `Function(int)`
  ///
  /// If `startAt` is passed, the timer will first go off at that time and
  /// subsequently run with period `duration`.
  ///
  /// If `exact` is passed as `true`, the timer will be created with Android's
  /// `AlarmManager.setRepeating`. When `exact` is `false` (the default), the
  /// timer will be created with `AlarmManager.setInexactRepeating`.
  ///
  /// If `wakeup` is passed as `true`, the device will be woken up when the
  /// alarm fires. If `wakeup` is false (the default), the device will not be
  /// woken up to service the alarm.
  ///
  /// If `rescheduleOnReboot` is passed as `true`, the alarm will be persisted
  /// across reboots. If `rescheduleOnReboot` is false (the default), the alarm
  /// will not be rescheduled after a reboot and will not be executed.
  ///
  /// Returns a [Future] that resolves to `true` on success and `false` on
  /// failure.
  static Future<bool> periodic(
    Duration duration,
    int id,
    Function callback, {
    DateTime startAt,
    bool alarmClock, // Essentially ignored.
    bool allowWhileIdle, // Essentially ignored.
    bool exact,
    bool wakeup,
    bool rescheduleOnReboot,
  }) async {
    //
    bool periodic = false;

    if (duration == null || duration.inSeconds <= 0) {
      getError("periodic(): `duration` is less than or zero.");
      return periodic;
    }

    if (id == null || id <= 0) {
      getError("periodic(): `id` is less than or zero.");
      return periodic;
    }

    CallbackHandle handle = PluginUtilities.getCallbackHandle(callback);
    assert(handle != null,
        "periodic(): `callback` is not a top-level or static function");
    if (handle == null) {
      getError("periodic(): `callback` is not a top-level or static function");
      return periodic;
    }

    periodic = await AlarmManager.init(
      startAt: startAt,
      alarmClock: alarmClock,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      wakeup: wakeup,
      rescheduleOnReboot: rescheduleOnReboot,
    );

    if (!periodic) return periodic;

    try {
      periodic = await AndroidAlarmManager.periodic(
        duration,
        id,
        callback,
        startAt: startAt ?? _startAt,
        exact: exact ?? _exact,
        wakeup: wakeup ?? _wakeup,
        rescheduleOnReboot: rescheduleOnReboot ?? _rescheduleOnReboot,
      );
    } catch (ex) {
      periodic = false;
      getError(ex);
    }
    return periodic;
  }

  /// Cancels a timer.
  ///
  /// If a timer has been scheduled with `id`, then this function will cancel
  /// it.
  ///
  /// Returns a [Future] that resolves to `true` on success and `false` on
  /// failure.
  static Future<bool> cancel(int id) async {
    bool cancel;
    try {
      cancel = await AndroidAlarmManager.cancel(id);
    } catch (ex) {
      cancel = false;
      getError(ex);
    }
    return cancel;
  }
}
