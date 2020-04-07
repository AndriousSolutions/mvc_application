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
///          Created  07 Mar 2020
///
///

import 'package:flutter/material.dart' show mustCallSuper, VoidCallback;

import 'package:package_info/package_info.dart' show PackageInfo;

import 'string_encryption.dart' show StringCrypt;

import 'package:firebase_remote_config/firebase_remote_config.dart' as r;

export 'package:firebase_remote_config/firebase_remote_config.dart'
    show LastFetchStatus, RemoteConfigSettings, RemoteConfigValue;

class RemoteConfig {
  RemoteConfig({
    String key,
    Map<String, dynamic> defaults,
    Duration expiration,
  }) {
    if (key != null && key.trim().isNotEmpty) _key = key;
    if (defaults != null && defaults.isNotEmpty) _defaults = defaults;
    if (expiration == null) {
      _expiration = const Duration(hours: 12);
    } else {
      _expiration = expiration;
    }
  }
  String _key;
  Map<String, dynamic> _defaults;
  Duration _expiration;

  StringCrypt _crypto;

  bool get isInit => _init;
  bool _init = false;

  static const INIT_ERROR =
      "Class RemoteConfig: Call init() before other functions and getters.";

  bool get activated => _activated;
  bool _activated = false;

  r.RemoteConfig get instance => _remoteConfig;
  r.RemoteConfig _remoteConfig;

  Future<bool> init() async {
    // Already called.
    if (_init) return _init;

    try {
      // Gets the instance of RemoteConfig for the default Firebase app.
      _remoteConfig ??= await r.RemoteConfig.instance;

      if (_defaults != null) _remoteConfig.setDefaults(_defaults);

      await _remoteConfig.fetch(expiration: _expiration);

      _activated = await _remoteConfig.activateFetched();

      if (_key == null) {
        PackageInfo info = await PackageInfo.fromPlatform();
        _key = _remoteConfig.getString(info.packageName.replaceAll(".", ""));
      }

      if (_key == null || _key.trim().isEmpty) {
        _crypto = StringCrypt();
        // You will need an encryption key. Save this.
        _key = await StringCrypt.generateRandomKey();
      } else {
        _crypto = StringCrypt(key: _key);
      }

      _init = true;
      // Fetch throttled.
    } on r.FetchThrottledException catch (ex) {
      _init = false;
      getError(ex);
    } catch (ex) {
      _init = false;
      getError(ex);
    }
    return _init;
  }

  @mustCallSuper
  void dispose() => _remoteConfig?.dispose();

  DateTime get lastFetchTime {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.lastFetchTime;
  }

  r.LastFetchStatus get lastFetchStatus {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.lastFetchStatus;
  }

  r.RemoteConfigSettings get remoteConfigSettings {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.remoteConfigSettings;
  }

  Future<void> setConfigSettings(r.RemoteConfigSettings remoteConfigSettings) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.setConfigSettings(remoteConfigSettings);
  }

  // Set the default values
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    if (defaults != null) {
      assert(_remoteConfig != null, INIT_ERROR);
      await _remoteConfig?.setDefaults(defaults);
    }
  }

  String getString(String key) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getString(key);
  }

  Future<String> getStringed(String param, [String key]) async {
    assert(_remoteConfig != null, INIT_ERROR);
    param = _remoteConfig?.getString(param);
    String string = await _crypto.de(param, key);
    if (_crypto.hasError) getError(_crypto.getError());
    return string;
  }

  int getInt(String key) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getInt(key);
  }

  double getDouble(String key) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getDouble(key);
  }

  bool getBool(String key) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getBool(key);
  }

  r.RemoteConfigValue getValue(String key) {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getValue(key);
  }

  Map<String, r.RemoteConfigValue> getAll() {
    assert(_remoteConfig != null, INIT_ERROR);
    return _remoteConfig?.getAll();
  }

  void addListener(VoidCallback listener) {
    assert(_remoteConfig != null, INIT_ERROR);
    _remoteConfig?.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    assert(_remoteConfig != null, INIT_ERROR);
    _remoteConfig?.removeListener(listener);
  }

  bool get hasError => _error != null;

  bool get inError => _error != null;
  Object _error;

  Exception getError([Object error]) {
    // Return the stored exception
    Exception ex = _error;
    // Empty the stored exception
    if (error == null) {
      _error = null;
    } else {
      if (error is! Exception) error = Exception(error.toString());
      _error = error;
    }
    // Return the exception just past if any.
    if (ex == null) ex = error;
    return ex;
  }
}
