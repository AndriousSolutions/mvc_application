///
/// Copyright (C) 2020 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  09 Apr 2020
///
///

///  NOTE: Add the following permission to your AndroidManifest.xml
///      <uses-permission android:name="android.permission.VIBRATE" />
///      <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

import 'dart:async' show Future;
import 'dart:math' show Random;
import 'dart:typed_data' show Int64List;
import 'dart:ui' show Color;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart';

import 'package:mvc_application/view.dart' show App;
import 'package:mvc_application/controller.dart' show HandleError;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

export 'dart:typed_data' show Int64List;

/// Export those classes the user is likely to use and pass in.
export 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show
        AndroidNotificationDetails,
        AndroidNotificationChannelAction,
        AndroidNotificationSound,
        AndroidBitmap,
        BigPictureStyleInformation,
        BigTextStyleInformation,
        Day,
        DefaultStyleInformation,
        DidReceiveLocalNotificationCallback,
        DrawableResourceAndroidBitmap,
        FilePathAndroidBitmap,
        GroupAlertBehavior,
        Importance,
        InitializationSettings,
        InboxStyleInformation,
        IOSNotificationDetails,
        IOSNotificationAttachment,
        MediaStyleInformation,
        NotificationAppLaunchDetails,
        NotificationDetails,
        NotificationVisibility,
        PendingNotificationRequest,
        Priority,
        RawResourceAndroidNotificationSound,
        RepeatInterval,
        SelectNotificationCallback,
        Time;

export 'package:flutter/material.dart' show Color;

/// The Notification feature for the phone.
class ScheduleNotifications with HandleError {
//
  ScheduleNotifications(
    this.channelId,
    this.channelName,
    this.channelDescription, {
    String? appIcon,
    TZDateTime? schedule,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    RepeatInterval? repeatInterval,
    Day? day,
    SelectNotificationCallback? onSelectNotification,
    bool? requestAlertPermission,
    bool? requestSoundPermission,
    bool? requestBadgePermission,
    bool? defaultPresentAlert,
    bool? defaultPresentSound,
    bool? defaultPresentBadge,
    DidReceiveLocalNotificationCallback? onDidReceiveLocalNotification,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    if (appIcon == null || appIcon.trim().isEmpty) {
      // Assign the app's icon.
      _appIcon = '@mipmap/ic_launcher';
    } else {
      _appIcon = appIcon.trim();
    }
    // Take in parameter values into private variables.
    _schedule = schedule;
    _title = title ?? '';
    _body = body ?? '';
    _payload = payload;
    _androidAllowWhileIdle = androidAllowWhileIdle ?? false;
    _icon = icon;
    _importance = importance ?? Importance.defaultImportance;
    _priority = priority ?? Priority.defaultPriority;
    _styleInformation = styleInformation;
    _playSound = playSound; // ?? false;
    _sound = sound;
    _enableVibration = enableVibration ?? false;
    _vibrationPattern = vibrationPattern;
    _groupKey = groupKey;
    _setAsGroupSummary = setAsGroupSummary;
    _groupAlertBehavior = groupAlertBehavior ?? GroupAlertBehavior.all;
    _autoCancel = autoCancel ?? true;
    _ongoing = ongoing;
    _color = color;
    _largeIcon = largeIcon;
    _onlyAlertOnce = onlyAlertOnce;
    _showWhen = showWhen ?? true;
    _channelShowBadge = channelShowBadge ?? true;
    _showProgress = showProgress ?? false;
    _maxProgress = maxProgress ?? 0;
    _progress = progress ?? 0;
    _indeterminate = indeterminate ?? false;
    _channelAction =
        channelAction ?? AndroidNotificationChannelAction.createIfNotExists;
    _enableLights = enableLights ?? true;
    _ledColor = ledColor ?? const Color.fromARGB(255, 255, 0, 0);
    _ledOnMs = ledOnMs ?? 1000;
    _ledOffMs = ledOffMs ?? 500;
    _ticker = ticker;
    _visibility = visibility ?? NotificationVisibility.private;
    _timeoutAfter = timeoutAfter;
    _category = category;
    _repeatInterval = repeatInterval;
    _day = day;
    _selectNotificationCallback = onSelectNotification;
    _requestAlertPermission = requestAlertPermission ?? true;
    _requestSoundPermission = requestSoundPermission ?? true;
    _requestBadgePermission = requestBadgePermission ?? true;
    _defaultPresentAlert = defaultPresentAlert ?? true;
    _defaultPresentSound = defaultPresentSound ?? true;
    _defaultPresentBadge = defaultPresentBadge ?? true;
    _onDidReceiveLocalNotification = onDidReceiveLocalNotification;
    _presentAlert = presentAlert ?? true;
    _presentSound = presentSound ?? true;
    _presentBadge = presentBadge ?? true;
    _soundFile = soundFile;
    _badgeNumber = badgeNumber;
    _attachments = attachments;
  }

  /// The icon representing the app implementing the notifications.
  String? _appIcon;

  /// The channel's id.
  /// Required for Android 8.0+.
  final String channelId;

  /// The channel's name.
  /// Required for Android 8.0+.
  final String channelName;

  /// The channel's description.
  /// Required for Android 8.0+.
  final String channelDescription;

  DateTime? _schedule;
  String? _title;
  String? _body;
  String? _payload;
  bool? _androidAllowWhileIdle;
  String? _icon;
  Importance? _importance;
  Priority? _priority;
  StyleInformation? _styleInformation;
  bool? _playSound;
  AndroidNotificationSound? _sound;
  bool? _enableVibration;
  List<int>? _vibrationPattern;
  String? _groupKey;
  bool? _setAsGroupSummary;
  GroupAlertBehavior? _groupAlertBehavior;
  bool? _autoCancel;
  bool? _ongoing;
  Color? _color;
  AndroidBitmap? _largeIcon;
  bool? _onlyAlertOnce;
  bool? _showWhen;
  bool? _channelShowBadge;
  bool? _showProgress;
  int? _maxProgress;
  int? _progress;
  bool? _indeterminate;
  AndroidNotificationChannelAction? _channelAction;
  bool? _enableLights;
  Color? _ledColor;
  int? _ledOnMs;
  int? _ledOffMs;
  String? _ticker;
  NotificationVisibility? _visibility;
  int? _timeoutAfter;
  String? _category;
  RepeatInterval? _repeatInterval;
  Day? _day;
//  Time _notificationTime;
  SelectNotificationCallback? _selectNotificationCallback;
  bool? _requestAlertPermission;
  bool? _requestSoundPermission;
  bool? _requestBadgePermission;
  bool? _defaultPresentAlert;
  bool? _defaultPresentSound;
  bool? _defaultPresentBadge;
  DidReceiveLocalNotificationCallback? _onDidReceiveLocalNotification;
  bool? _presentAlert;
  bool? _presentSound;
  bool? _presentBadge;
  String? _soundFile;
  int? _badgeNumber;
  List<IOSNotificationAttachment>? _attachments;

  @mustCallSuper
  Future<bool?> init({
    String? appIcon,
    DateTime? schedule,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    RepeatInterval? repeatInterval,
    Day? day,
    Time? notificationTime,
    SelectNotificationCallback? onSelectNotification,
    bool? requestAlertPermission,
    bool? requestSoundPermission,
    bool? requestBadgePermission,
    bool? defaultPresentAlert,
    bool? defaultPresentSound,
    bool? defaultPresentBadge,
    DidReceiveLocalNotificationCallback? onDidReceiveLocalNotification,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) async {
    // No need to continue.
    if (_init!) {
      return _init;
    }

    if (appIcon != null && appIcon.trim().isEmpty) {
      appIcon = null;
    }
    appIcon ??= _appIcon;
    // init parameters take over initial parameter values.
    if (schedule != null) {
      _schedule = schedule;
    }
    if (title != null) {
      _title = title;
    }
    if (body != null) {
      _body = body;
    }
    if (payload != null) {
      _payload = payload;
    }
    if (androidAllowWhileIdle != null) {
      _androidAllowWhileIdle = androidAllowWhileIdle;
    }
    if (icon != null) {
      _icon = icon;
    }
    if (importance != null) {
      _importance = importance;
    }
    if (priority != null) {
      _priority = priority;
    }
    if (styleInformation != null) {
      _styleInformation = styleInformation;
    }
    if (playSound != null) {
      _playSound = playSound;
    }
    if (sound != null) {
      _sound = sound;
    }
    if (enableVibration != null) {
      _enableVibration = enableVibration;
    }
    if (vibrationPattern != null) {
      _vibrationPattern = vibrationPattern;
    }
    if (groupKey != null) {
      _groupKey = groupKey;
    }
    if (setAsGroupSummary != null) {
      _setAsGroupSummary = setAsGroupSummary;
    }
    if (groupAlertBehavior != null) {
      _groupAlertBehavior = groupAlertBehavior;
    }
    if (autoCancel != null) {
      _autoCancel = autoCancel;
    }
    if (ongoing != null) {
      _ongoing = ongoing;
    }
    if (color != null) {
      _color = color;
    }
    if (largeIcon != null) {
      _largeIcon = largeIcon;
    }
    if (onlyAlertOnce != null) {
      _onlyAlertOnce = onlyAlertOnce;
    }
    if (showWhen != null) {
      _showWhen = showWhen;
    }
    if (channelShowBadge != null) {
      _channelShowBadge = channelShowBadge;
    }
    if (showProgress != null) {
      _showProgress = showProgress;
    }
    if (maxProgress != null) {
      _maxProgress = maxProgress;
    }
    if (progress != null) {
      _progress = progress;
    }
    if (indeterminate != null) {
      _indeterminate = indeterminate;
    }
    if (channelAction != null) {
      _channelAction = channelAction;
    }
    if (enableLights != null) {
      _enableLights = enableLights;
    }
    if (ledColor != null) {
      _ledColor = ledColor;
    }
    if (ledOnMs != null) {
      _ledOnMs = ledOnMs;
    }
    if (ledOffMs != null) {
      _ledOffMs = ledOffMs;
    }
    if (ticker != null) {
      _ticker = ticker;
    }
    if (visibility != null) {
      _visibility = visibility;
    }
    if (timeoutAfter != null) {
      _timeoutAfter = timeoutAfter;
    }
    if (category != null) {
      _category = category;
    }
    if (repeatInterval != null) {
      _repeatInterval = repeatInterval;
    }
    if (day != null) {
      _day = day;
    }
    onSelectNotification ??=
        _selectNotificationCallback ?? _onSelectNotification as Future<dynamic> Function(String?)?;
    requestAlertPermission ??= _requestAlertPermission;
    requestSoundPermission ??= _requestSoundPermission;
    requestBadgePermission ??= _requestBadgePermission;
    defaultPresentAlert ??= _defaultPresentAlert;
    defaultPresentSound ??= _defaultPresentSound;
    defaultPresentBadge ??= _defaultPresentBadge;
    onDidReceiveLocalNotification ??= _onDidReceiveLocalNotification;
    if (presentAlert != null) {
      _presentAlert = presentAlert;
    }
    if (presentSound != null) {
      _presentSound = presentSound;
    }
    if (presentBadge != null) {
      _presentBadge = presentBadge;
    }
    if (soundFile != null) {
      _soundFile = soundFile;
    }
    if (badgeNumber != null) {
      _badgeNumber = badgeNumber;
    }
    if (attachments != null) {
      _attachments = attachments;
    }

    //
    try {
      final initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: requestAlertPermission!,
        requestBadgePermission: requestSoundPermission!,
        requestSoundPermission: requestBadgePermission!,
        defaultPresentAlert: defaultPresentAlert!,
        defaultPresentSound: defaultPresentSound!,
        defaultPresentBadge: defaultPresentBadge!,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification ??
            ((int id, String? title, String? body, String? payload) =>
                onSelectNotification!(payload)),
      );

      WidgetsFlutterBinding.ensureInitialized();

      final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings(_appIcon!),
        iOS: initializationSettingsIOS,
      );

      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      _init = await _flutterLocalNotificationsPlugin!.initialize(
          initializationSettings,
          onSelectNotification: onSelectNotification);
    } catch (ex) {
      getError(ex);
      _init = false;
    }
    return _init;
  }

  @mustCallSuper
  void dispose() {
    // Not really necessary but provides a dispose() function for the user.
    _flutterLocalNotificationsPlugin = null;
  }

  /// Returns the underlying platform-specific implementation of given generic type T, which
  /// must be a concrete subclass of [FlutterLocalNotificationsPlatform](https://pub.dev/documentation/flutter_local_notifications_platform_interface/latest/flutter_local_notifications_platform_interface/FlutterLocalNotificationsPlatform-class.html).
  Future<bool> resolveIOSImplementation({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    assert(_init!, 'ScheduleNotifications: Failed to call init() first!');

    if (!_init!) {
      return false;
    }
    IOSFlutterLocalNotificationsPlugin? implementation;
    try {
      implementation = _flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
    } catch (ex) {
      getError(ex);
    }
    var request = implementation != null;
    if (request) {
      request = await (implementation!.requestPermissions(
        alert: alert,
        badge: badge,
        sound: sound,
      ) as Future<bool>);
    }
    return request;
  }

  // plugin
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // Flag indicating it's initialized.
  bool? _init = false;
  bool? get initialized => _init;

  int show({
    int? id,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    //
    final notificationSpecifics = _notificationDetails(
      title,
      body,
      payload,
      androidAllowWhileIdle,
      icon,
      importance,
      priority,
      styleInformation,
      playSound,
      sound,
      enableVibration,
      vibrationPattern,
      groupKey,
      setAsGroupSummary,
      groupAlertBehavior,
      autoCancel,
      ongoing,
      color,
      largeIcon,
      onlyAlertOnce,
      showWhen,
      channelShowBadge,
      showProgress,
      maxProgress,
      progress,
      indeterminate,
      channelAction,
      enableLights,
      ledColor,
      ledOnMs,
      ledOffMs,
      ticker,
      visibility,
      timeoutAfter,
      category,
      presentAlert,
      presentSound,
      presentBadge,
      soundFile,
      badgeNumber,
      attachments,
    );

    if (notificationSpecifics == null) {
      id = -1;
    } else {
      //
      try {
        //
        if (id == null || id < 0) {
          id = Random().nextInt(999);
        }

        _flutterLocalNotificationsPlugin!.show(
          id,
          title,
          body,
          notificationSpecifics,
          payload: payload,
        );
      } catch (ex) {
        id = -1;
        getError(ex);
      }
    }
    return id;
  }

  int schedule(
    TZDateTime? schedule, {
    int? id,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    UILocalNotificationDateInterpretation? uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    // May have already been supplied.
    schedule ??= _schedule as TZDateTime;

    // Too late!
    if (schedule == null || DateTime.now().isAfter(schedule)) {
      return -1;
    }

    final notificationSpecifics = _notificationDetails(
      title,
      body,
      payload,
      androidAllowWhileIdle,
      icon,
      importance,
      priority,
      styleInformation,
      playSound,
      sound,
      enableVibration,
      vibrationPattern,
      groupKey,
      setAsGroupSummary,
      groupAlertBehavior,
      autoCancel,
      ongoing,
      color,
      largeIcon,
      onlyAlertOnce,
      showWhen,
      channelShowBadge,
      showProgress,
      maxProgress,
      progress,
      indeterminate,
      channelAction,
      enableLights,
      ledColor,
      ledOnMs,
      ledOffMs,
      ticker,
      visibility,
      timeoutAfter,
      category,
      presentAlert,
      presentSound,
      presentBadge,
      soundFile,
      badgeNumber,
      attachments,
    );

    if (notificationSpecifics == null) {
      id = -1;
    } else {
      //
      if (id == null || id < 0) {
        id = Random().nextInt(999);
      }

      try {
        //
        _flutterLocalNotificationsPlugin!.zonedSchedule(
          id,
          title,
          body,
          schedule,
          notificationSpecifics,
          uiLocalNotificationDateInterpretation:
              uiLocalNotificationDateInterpretation!,
          androidAllowWhileIdle: androidAllowWhileIdle!,
          payload: payload,
          matchDateTimeComponents: matchDateTimeComponents,
        );
      } catch (ex) {
        id = -1;
        getError(ex);
      }
    }
    return id;
  }

  int periodicallyShow(
    RepeatInterval? repeatInterval, {
    int? id,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    repeatInterval ??= _repeatInterval;

    if (repeatInterval == null) {
      return -1;
    }

    //
    final notificationSpecifics = _notificationDetails(
      title,
      body,
      payload,
      androidAllowWhileIdle,
      icon,
      importance,
      priority,
      styleInformation,
      playSound,
      sound,
      enableVibration,
      vibrationPattern,
      groupKey,
      setAsGroupSummary,
      groupAlertBehavior,
      autoCancel,
      ongoing,
      color,
      largeIcon,
      onlyAlertOnce,
      showWhen,
      channelShowBadge,
      showProgress,
      maxProgress,
      progress,
      indeterminate,
      channelAction,
      enableLights,
      ledColor,
      ledOnMs,
      ledOffMs,
      ticker,
      visibility,
      timeoutAfter,
      category,
      presentAlert,
      presentSound,
      presentBadge,
      soundFile,
      badgeNumber,
      attachments,
    );

    if (notificationSpecifics == null) {
      id = -1;
    } else {
      //
      try {
        //
        if (id == null || id < 0) {
          id = Random().nextInt(999);
        }

        _flutterLocalNotificationsPlugin!.periodicallyShow(
          id,
          title,
          body,
          repeatInterval,
          notificationSpecifics,
          payload: payload,
        );
      } catch (ex) {
        id = -1;
        getError(ex);
      }
    }
    return id;
  }

  int showDailyAtTime(
    TZDateTime? schedule, {
    int? id,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    UILocalNotificationDateInterpretation? uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    schedule ??= _schedule as TZDateTime;

    if (schedule == null) {
      return -1;
    }

    //
    final notificationSpecifics = _notificationDetails(
      title,
      body,
      payload,
      androidAllowWhileIdle,
      icon,
      importance,
      priority,
      styleInformation,
      playSound,
      sound,
      enableVibration,
      vibrationPattern,
      groupKey,
      setAsGroupSummary,
      groupAlertBehavior,
      autoCancel,
      ongoing,
      color,
      largeIcon,
      onlyAlertOnce,
      showWhen,
      channelShowBadge,
      showProgress,
      maxProgress,
      progress,
      indeterminate,
      channelAction,
      enableLights,
      ledColor,
      ledOnMs,
      ledOffMs,
      ticker,
      visibility,
      timeoutAfter,
      category,
      presentAlert,
      presentSound,
      presentBadge,
      soundFile,
      badgeNumber,
      attachments,
    );

    if (notificationSpecifics == null) {
      id = -1;
    } else {
      //
      try {
        //
        if (id == null || id < 0) {
          id = Random().nextInt(999);
        }

        _flutterLocalNotificationsPlugin!.zonedSchedule(
          id,
          title,
          body,
          schedule,
          notificationSpecifics,
          payload: payload,
          uiLocalNotificationDateInterpretation:
              uiLocalNotificationDateInterpretation!,
          androidAllowWhileIdle: androidAllowWhileIdle!,
          matchDateTimeComponents: matchDateTimeComponents,
        );
      } catch (ex) {
        id = -1;
        getError(ex);
      }
    }
    return id;
  }

  int showWeeklyAtDayAndTime(
    Day? day,
    TZDateTime? schedule, {
    int? id,
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    NotificationDetails? notificationDetails,
    UILocalNotificationDateInterpretation? uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  }) {
    day ??= _day;

    schedule ??= _schedule as TZDateTime;

    if (day == null || schedule == null) {
      return -1;
    }

    //
    final notificationSpecifics = _notificationDetails(
      title,
      body,
      payload,
      androidAllowWhileIdle,
      icon,
      importance,
      priority,
      styleInformation,
      playSound,
      sound,
      enableVibration,
      vibrationPattern,
      groupKey,
      setAsGroupSummary,
      groupAlertBehavior,
      autoCancel,
      ongoing,
      color,
      largeIcon,
      onlyAlertOnce,
      showWhen,
      channelShowBadge,
      showProgress,
      maxProgress,
      progress,
      indeterminate,
      channelAction,
      enableLights,
      ledColor,
      ledOnMs,
      ledOffMs,
      ticker,
      visibility,
      timeoutAfter,
      category,
      presentAlert,
      presentSound,
      presentBadge,
      soundFile,
      badgeNumber,
      attachments,
    );

    if (notificationSpecifics == null) {
      id = -1;
    } else {
      //
      try {
        //
        if (id == null || id < 0) {
          id = Random().nextInt(999);
        }

        _flutterLocalNotificationsPlugin!.zonedSchedule(
          id,
          title,
          body,
          schedule,
          notificationDetails!,
          uiLocalNotificationDateInterpretation:
              uiLocalNotificationDateInterpretation!,
          androidAllowWhileIdle: androidAllowWhileIdle!,
          payload: payload,
          matchDateTimeComponents: matchDateTimeComponents,
        );
      } catch (ex) {
        id = -1;
        getError(ex);
      }
    }
    return id;
  }

  NotificationDetails? _notificationDetails(
    String? title,
    String? body,
    String? payload,
    bool? androidAllowWhileIdle,
    String? icon,
    Importance? importance,
    Priority? priority,
    StyleInformation? styleInformation,
    bool? playSound,
    AndroidNotificationSound? sound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    Color? color,
    AndroidBitmap? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? ticker,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    String? category,
    bool? presentAlert,
    bool? presentSound,
    bool? presentBadge,
    String? soundFile,
    int? badgeNumber,
    List<IOSNotificationAttachment>? attachments,
  ) {
    //
    NotificationDetails? notificationSpecifics;

    // Failed to initialized.
    if (!_init!) {
      if (hasError) {
        assert(false, errorMsg);
      } else {
        assert(false, 'ScheduleNotifications: Failed to call init() first!');
      }
      return notificationSpecifics;
    }

    title ??= _title;
    body ??= _body;
    payload ??= _payload;
    androidAllowWhileIdle ??= _androidAllowWhileIdle;
    icon ??= _icon;
    importance ??= _importance;
    priority ??= _priority;
    styleInformation ??= _styleInformation;
    playSound ??= _playSound;
    sound ??= _sound;
    enableVibration ??= _enableVibration;
    vibrationPattern ??= _vibrationPattern;
    groupKey ??= _groupKey;
    setAsGroupSummary ??= _setAsGroupSummary;
    groupAlertBehavior ??= _groupAlertBehavior;
    autoCancel ??= _autoCancel;
    ongoing ??= _ongoing;
    color ??= _color;
    largeIcon ??= _largeIcon;
    onlyAlertOnce ??= _onlyAlertOnce;
    showWhen ??= _showWhen;
    channelShowBadge ??= _channelShowBadge;
    showProgress ??= _showProgress;
    maxProgress ??= _maxProgress;
    progress ??= _progress;
    indeterminate ??= _indeterminate;
    channelAction ??= _channelAction;
    enableLights ??= _enableLights;
    ledColor ??= _ledColor;
    ledOnMs ??= _ledOnMs;
    ledOffMs ??= _ledOffMs;
    ticker ??= _ticker;
    visibility ??= _visibility;
    timeoutAfter ??= _timeoutAfter;
    category ??= _category;
    presentAlert ??= _presentAlert;
    presentSound ??= _presentSound;
    presentBadge ??= _presentBadge;
    soundFile ??= _soundFile;
    badgeNumber ??= _badgeNumber;
    attachments ??= _attachments;

    // Play the sound if supplied a sound.
    if (playSound == null) {
      if (sound == null) {
        playSound = false;
      } else {
        playSound = true;
      }
    }

    // If to vibrate then do so.
    if (enableVibration! &&
        (vibrationPattern == null || vibrationPattern.isEmpty)) {
      vibrationPattern = Int64List(4);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 1000;
      vibrationPattern[2] = 5000;
      vibrationPattern[3] = 2000;
    }

    AndroidNotificationDetails androidSettings;
    IOSNotificationDetails iOSSettings;

    try {
      androidSettings = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription,
        icon: icon,
        importance: importance!,
        priority: priority!,
        styleInformation: styleInformation,
        playSound: playSound,
        sound: sound,
        enableVibration: enableVibration,
        vibrationPattern: vibrationPattern as Int64List?,
        groupKey: groupKey,
        setAsGroupSummary: setAsGroupSummary!,
        groupAlertBehavior: groupAlertBehavior!,
        autoCancel: autoCancel!,
        ongoing: ongoing!,
        color: color,
        largeIcon: largeIcon,
        onlyAlertOnce: onlyAlertOnce!,
        showWhen: showWhen!,
        channelShowBadge: channelShowBadge!,
        showProgress: showProgress!,
        maxProgress: maxProgress!,
        progress: progress!,
        indeterminate: indeterminate!,
        channelAction: channelAction!,
        enableLights: enableLights!,
        ledColor: ledColor,
        ledOnMs: ledOnMs,
        ledOffMs: ledOffMs,
        ticker: ticker,
        visibility: visibility,
        timeoutAfter: timeoutAfter,
        category: category,
      );
    } catch (ex) {
      getError(ex);
      return notificationSpecifics;
    }

    try {
      iOSSettings = IOSNotificationDetails(
        presentAlert: presentAlert,
        presentSound: presentSound,
        presentBadge: presentBadge,
        sound: soundFile,
        badgeNumber: badgeNumber,
        attachments: attachments,
      );

      notificationSpecifics = NotificationDetails(
        android: androidSettings,
        iOS: iOSSettings,
      );
    } catch (ex) {
      notificationSpecifics = null;
      getError(ex);
    }
    return notificationSpecifics;
  }

  /// Cancel a specific notification.
  Future<void> cancel(int id) async {
    if (id == null || id < 0) {
      return;
    }
    await _flutterLocalNotificationsPlugin!.cancel(id);
    return;
  }

  /// Cancel all Notifications.
  Future<void> cancelAll() => _flutterLocalNotificationsPlugin!.cancelAll();

  /// Returns info on if a notification created from this plugin had been used to launch the application.
  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() =>
      _flutterLocalNotificationsPlugin!.getNotificationAppLaunchDetails();

  /// Returns a list of notifications pending to be delivered/shown.
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() =>
      _flutterLocalNotificationsPlugin!.pendingNotificationRequests();

  void _onSelectNotification(String payload) {
    if (payload != null || payload.trim().isNotEmpty) {
      showDialog(
        context: App.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            title: const Text('PayLoad'),
            content: Text('Payload : $payload'),
          );
        },
      );
    }
  }
}
