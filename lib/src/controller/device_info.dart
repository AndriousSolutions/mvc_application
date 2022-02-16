///
/// Copyright (C) 2019 Andrious Solutions c/o Jakub Homlala
///
/// https://github.com/Andrious/catcher/blob/de2e19d0be34b35382c29903f546d4119607bd1c/lib/core/catcher.dart#L121
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
///          Created  11 Feb 2019
///
///
//import 'dart:io' show Platform;
// Replace 'dart:io' for Web applications
import 'package:universal_platform/universal_platform.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:device_info_plus/device_info_plus.dart'
    show AndroidDeviceInfo, DeviceInfoPlugin, IosDeviceInfo;

// ignore: avoid_classes_with_only_static_members
/// Supplies the devices information.
class DeviceInfo {
  static bool _init = false;
  static final Map<String, dynamic> _deviceParameters = {};
//  static Map<String, dynamic> _applicationParameters = Map();

  /// Collect all the Device's information.
  static Future<Map<String, dynamic>> initAsync() => init();

  /// Collect all the Device's information.
  @Deprecated('Replaced by initAsync for API consistency.')
  static Future<Map<String, dynamic>> init() async {
    if (_init) {
      return _deviceParameters;
    }
    _init = true;
    // Running in the Web.
    if (kIsWeb) {
      return _deviceParameters;
    }
    if (UniversalPlatform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      _loadAndroidParameters(info);
    } else if (UniversalPlatform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      _loadiOSParameters(info);
    } else if (UniversalPlatform.isWindows) {
    } else if (UniversalPlatform.isFuchsia) {
    } else if (UniversalPlatform.isLinux) {
    } else if (UniversalPlatform.isMacOS) {}
    return _deviceParameters;
  }

  // Android

  /// The name of the underlying board, like "goldfish".
  static String get board => _deviceParameters['board'] ?? '';

  /// The system bootloader version number.
  static String get bootloader => _deviceParameters['bootloader'] ?? '';

  /// The consumer-visible brand with which the product/hardware will be associated, if any.
  static String get brand => _deviceParameters['brand'] ?? '';

  /// The name of the industrial design.
  static String get device => _deviceParameters['device'] ?? '';

  /// A build ID string meant for displaying to the user.
  static String get display => _deviceParameters['display'] ?? '';

  /// A string that uniquely identifies this build.
  static String get fingerprint => _deviceParameters['fingerprint'] ?? '';

  /// The name of the hardware (from the kernel command line or /proc).
  static String get hardware => _deviceParameters['hardware'] ?? '';

  /// Hostname.
  static String get host => _deviceParameters['host'] ?? '';

  /// Either a changelist number, or a label like "M4-rc20".
  static String get id => _deviceParameters['id'] ?? '';

  /// The manufacturer of the product/hardware.
  static String get manufacturer => _deviceParameters['manufacturer'] ?? '';

  /// The end-user-visible name for the end product.
  static String get model => _deviceParameters['model'] ?? '';

  /// The name of the overall product.
  static String get product => _deviceParameters['product'] ?? '';

  /// An ordered list of 32 bit ABIs supported by this device.
  static String get supported32BitAbis =>
      _deviceParameters['supported32BitAbis'] ?? '';

  /// An ordered list of 64 bit ABIs supported by this device.
  static String get supported64BitAbis =>
      _deviceParameters['supported64BitAbis'] ?? '';

  /// An ordered list of ABIs supported by this device.
  static String get supportedAbis => _deviceParameters['supportedAbis'] ?? '';

  /// Comma-separated tags describing the build, like "unsigned,debug".
  static String get tags => _deviceParameters['tags'] ?? '';

  /// The type of build, like "user" or "eng".
  static String get type => _deviceParameters['type'] ?? '';

  /// `false` if the application is running in an emulator, `true` otherwise.
  static String get isPhysicalDevice =>
      _deviceParameters['isPhysicalDevice'] ?? '';

  /// The Android hardware device ID that is unique between the device + user and app signing.
  static String get androidId => _deviceParameters['androidId'] ?? '';

  /// The base OS build the product is based on.
  static String get versionBaseOs => _deviceParameters['versionBaseOs'] ?? '';

  /// The current development codename, or the string "REL" if this is a release build.
  static String get versionCodename =>
      _deviceParameters['versionCodename'] ?? '';

  /// The internal value used by the underlying source control to represent this build.
  static String get versionIncremental =>
      _deviceParameters['versionIncremental'] ?? '';

  /// The developer preview revision of a prerelease SDK.
  static String get versionPreviewSdk =>
      _deviceParameters['versionPreviewSdk'] ?? '';

  /// The user-visible version string.
  static String get versionRelease => _deviceParameters['versionRelease'] ?? '';

  /// The user-visible SDK version of the framework.
  ///
  /// Possible values are defined in: https://developer.android.com/reference/android/os/Build.VERSION_CODES.html
  static String get versionSdk => _deviceParameters['versionSdk'] ?? '';

  /// The user-visible security patch level.
  static String get versionSecurityPatch =>
      _deviceParameters['versionSecurityPatch'] ?? '';

  // iOS

  /// Device name.
  static String get name => _deviceParameters['name'] ?? '';

  /// The name of the current operating system.
  static String get systemName => _deviceParameters['systemName'] ?? '';

  /// The current operating system version.
  static String get systemVersion => _deviceParameters['systemVersion'] ?? '';

  /// Localized name of the device model.
  static String get localizedModel => _deviceParameters['localizedModel'] ?? '';

  /// Unique UUID value identifying the current device.
  static String get identifierForVendor =>
      _deviceParameters['identifierForVendor'] ?? '';

  /// Operating system information derived from `sys/utsname.h`.
  static String get utsname => _deviceParameters['utsname'] ?? '';

  /// Operating system name.
  static String get utsnameSysname => _deviceParameters['utsnameSysname'] ?? '';

  /// Network node name.
  static String get utsnameNodename =>
      _deviceParameters['utsnameNodename'] ?? '';

  /// Release level.
  static String get utsnameRelease => _deviceParameters['utsnameRelease'] ?? '';

  /// Version level.
  static String get utsnameVersion => _deviceParameters['utsnameVersion'] ?? '';

  /// Hardware type (e.g. 'iPhone7,1' for iPhone 6 Plus).
  static String get utsnameMachine => _deviceParameters['utsnameMachine'] ?? '';

  static void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    _deviceParameters['id'] = androidDeviceInfo.id;
    _deviceParameters['androidId'] = androidDeviceInfo.androidId;
    _deviceParameters['board'] = androidDeviceInfo.board;
    _deviceParameters['bootloader'] = androidDeviceInfo.bootloader;
    _deviceParameters['brand'] = androidDeviceInfo.brand;
    _deviceParameters['device'] = androidDeviceInfo.device;
    _deviceParameters['display'] = androidDeviceInfo.display;
    _deviceParameters['fingerprint'] = androidDeviceInfo.fingerprint;
    _deviceParameters['hardware'] = androidDeviceInfo.hardware;
    _deviceParameters['host'] = androidDeviceInfo.host;
    _deviceParameters['isPsychicalDevice'] = androidDeviceInfo.isPhysicalDevice;
    _deviceParameters['manufacturer'] = androidDeviceInfo.manufacturer;
    _deviceParameters['model'] = androidDeviceInfo.model;
    _deviceParameters['product'] = androidDeviceInfo.product;
    _deviceParameters['supported32BitAbis'] =
        androidDeviceInfo.supported32BitAbis;
    _deviceParameters['supported64BitAbis'] =
        androidDeviceInfo.supported64BitAbis;
    _deviceParameters['supportedAbis'] = androidDeviceInfo.supportedAbis;
    _deviceParameters['tags'] = androidDeviceInfo.tags;
    _deviceParameters['type'] = androidDeviceInfo.type;
    _deviceParameters['versionBaseOs'] = androidDeviceInfo.version.baseOS;
    _deviceParameters['versionCodename'] = androidDeviceInfo.version.codename;
    _deviceParameters['versionIncremental'] =
        androidDeviceInfo.version.incremental;
    _deviceParameters['versionPreviewSdk'] =
        androidDeviceInfo.version.previewSdkInt;
    _deviceParameters['versionRelease'] = androidDeviceInfo.version.release;
    _deviceParameters['versionSdk'] = androidDeviceInfo.version.sdkInt;
    _deviceParameters['versionSecurityPatch'] =
        androidDeviceInfo.version.securityPatch;
  }

  static void _loadiOSParameters(IosDeviceInfo iosInfo) {
    _deviceParameters['name'] = iosInfo.name;
    _deviceParameters['systemName'] = iosInfo.systemName;
    _deviceParameters['systemVersion'] = iosInfo.systemVersion;
    _deviceParameters['model'] = iosInfo.model;
    _deviceParameters['localizedModel'] = iosInfo.localizedModel;
    _deviceParameters['identifierForVendor'] = iosInfo.identifierForVendor;
    _deviceParameters['isPsychicalDevice'] = iosInfo.isPhysicalDevice;
    _deviceParameters['utsname'] = iosInfo.utsname;

    _deviceParameters['utsnameSysname'] = iosInfo.utsname.sysname;
    _deviceParameters['utsnameNodename'] = iosInfo.utsname.nodename;
    _deviceParameters['utsnameRelease'] = iosInfo.utsname.release;
    _deviceParameters['utsnameVersion'] = iosInfo.utsname.version;
    _deviceParameters['utsnameMachine'] = iosInfo.utsname.machine;
  }
}
