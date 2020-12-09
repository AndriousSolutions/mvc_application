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
import 'package:device_info/device_info.dart'
    show AndroidDeviceInfo, DeviceInfoPlugin, IosDeviceInfo;

// ignore: avoid_classes_with_only_static_members
/// Supplies the devices information.
class DeviceInfo {
  static bool _init = false;
  static final Map<String, dynamic> _deviceParameters = {};
//  static Map<String, dynamic> _applicationParameters = Map();

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
  static String get id => _deviceParameters['id'] ?? '';
  static String get androidId => _deviceParameters['androidId'] ?? '';
  static String get board => _deviceParameters['board'] ?? '';
  static String get bootloader => _deviceParameters['bootloader'] ?? '';
  static String get brand => _deviceParameters['brand'] ?? '';
  static String get device => _deviceParameters['device'] ?? '';
  static String get display => _deviceParameters['display'] ?? '';
  static String get fingerprint => _deviceParameters['fingerprint'] ?? '';
  static String get hardware => _deviceParameters['hardware'] ?? '';
  static String get host => _deviceParameters['host'] ?? '';
  static String get isPhysicalDevice =>
      _deviceParameters['isPhysicalDevice'] ?? '';
  static String get manufacturer => _deviceParameters['manufacturer'] ?? '';
  static String get model => _deviceParameters['model'] ?? '';
  static String get product => _deviceParameters['product'] ?? '';
  static String get tags => _deviceParameters['tags'] ?? '';
  static String get type => _deviceParameters['type'] ?? '';
  static String get versionBaseOs => _deviceParameters['versionBaseOs'] ?? '';
  static String get versionCodename =>
      _deviceParameters['versionCodename'] ?? '';
  static String get versionIncremental =>
      _deviceParameters['versionIncremental'] ?? '';
  static String get versionPreviewSdk =>
      _deviceParameters['versionPreviewSdk'] ?? '';
  static String get versionRelease => _deviceParameters['versionRelease'] ?? '';
  static String get versionSdk => _deviceParameters['versionSdk'] ?? '';
  static String get versionSecurityPatch =>
      _deviceParameters['versionSecurityPatch'] ?? '';
  // iOS
  static String get name => _deviceParameters['name'] ?? '';
  static String get identifierForVendor =>
      _deviceParameters['identifierForVendor'] ?? '';
  static String get localizedModel => _deviceParameters['localizedModel'] ?? '';
  static String get systemName => _deviceParameters['systemName'] ?? '';
  static String get utsnameVersion => _deviceParameters['utsnameVersion'] ?? '';
  static String get utsnameRelease => _deviceParameters['utsnameRelease'] ?? '';
  static String get utsnameMachine => _deviceParameters['utsnameMachine'] ?? '';
  static String get utsnameNodename =>
      _deviceParameters['utsnameNodename'] ?? '';
  static String get utsnameSysname => _deviceParameters['utsnameSysname'] ?? '';

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
    _deviceParameters['model'] = iosInfo.model;
    _deviceParameters['isPsychicalDevice'] = iosInfo.isPhysicalDevice;
    _deviceParameters['name'] = iosInfo.name;
    _deviceParameters['identifierForVendor'] = iosInfo.identifierForVendor;
    _deviceParameters['localizedModel'] = iosInfo.localizedModel;
    _deviceParameters['systemName'] = iosInfo.systemName;
    _deviceParameters['utsnameVersion'] = iosInfo.utsname.version;
    _deviceParameters['utsnameRelease'] = iosInfo.utsname.release;
    _deviceParameters['utsnameMachine'] = iosInfo.utsname.machine;
    _deviceParameters['utsnameNodename'] = iosInfo.utsname.nodename;
    _deviceParameters['utsnameSysname'] = iosInfo.utsname.sysname;
  }
}
