import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as t;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/// Supply timezone information.
class TimeZone {
  /// A factory constructor for only one single instance.
  factory TimeZone() => _this ?? TimeZone._();

  TimeZone._() {
    initializeTimeZones();
  }
  static TimeZone? _this;

  /// Supply a String describing the current timezone.
  Future<String> getTimeZoneName() async =>
      FlutterNativeTimezone.getLocalTimezone();

  /// Returns a Location object from the specified timezone.
  Future<t.Location> getLocation([String? timeZoneName]) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }
    return t.getLocation(timeZoneName);
  }
}
