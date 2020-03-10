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

import 'package:mvc_application/view.dart' show App;

import 'package:firebase_remote_config/firebase_remote_config.dart' as r;

export 'package:firebase_remote_config/firebase_remote_config.dart'
    show LastFetchStatus, RemoteConfigSettings, RemoteConfigValue;

import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class RemoteConfig {
  RemoteConfig({
    this.defaults,
    this.expiration = const Duration(seconds: 1),
    this.mark,
  }) {
    _crypto = PlatformStringCryptor();
    _mark = mark;
  }
  final Map<String, dynamic> defaults;
  final Duration expiration;
  PlatformStringCryptor _crypto;
  String mark;
  String _mark;

  bool get isInit => _init;
  bool _init = false;

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

      if (defaults != null) _remoteConfig.setDefaults(defaults);

      await _remoteConfig.fetch(expiration: expiration);

      _activated = await _remoteConfig.activateFetched();

      _mark ??= App.packageName.replaceAll(".", "");

      _mark = _remoteConfig?.getString(_mark);

      // You will need an encryption key. Save this.
      if (_mark == null || _mark.isEmpty)
        _mark = await _crypto.generateRandomKey();

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

  DateTime get lastFetchTime => _remoteConfig?.lastFetchTime;

  r.LastFetchStatus get lastFetchStatus => _remoteConfig?.lastFetchStatus;

  r.RemoteConfigSettings get remoteConfigSettings =>
      _remoteConfig?.remoteConfigSettings;

  Future<void> setConfigSettings(r.RemoteConfigSettings remoteConfigSettings) =>
      _remoteConfig?.setConfigSettings(remoteConfigSettings);

  // Set the default values
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    if (defaults != null) await _remoteConfig.setDefaults(defaults);
  }

  String getString(String key) => _remoteConfig?.getString(key);

  String getStringed(String key) => _remoteConfig?.getString(key);

  int getInt(String key) => _remoteConfig?.getInt(key);

  double getDouble(String key) => _remoteConfig?.getDouble(key);

  bool getBool(String key) => _remoteConfig?.getBool(key);

  r.RemoteConfigValue getValue(String key) => _remoteConfig?.getValue(key);

  Map<String, r.RemoteConfigValue> getAll() => _remoteConfig?.getAll();

  void addListener(VoidCallback listener) =>
      _remoteConfig?.addListener(listener);

  void removeListener(VoidCallback listener) =>
      _remoteConfig?.removeListener(listener);

  bool get hasError => _error != null;
  bool get inError => _error != null;
  Object _error;

  Exception getError([Object error]) {
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

  Future<String> en(String data, [String mark]) => encrypt(data, mark);

  Future<String> encrypt(String data, [String mark]) async {
    String cryp;
    try {
      cryp = await _crypto.encrypt(data, mark ??= _mark);
    } catch (ex) {
      cryp = "";
      getError(ex);
    }
    return cryp;
  }

  Future<String> de(String data, [String mark]) => decrypt(data, mark);

  Future<String> decrypt(String data, [String mark]) async {
    String decryp;
    try {
      decryp = await _crypto.decrypt(data, mark ??= _mark);
    } catch (ex) {
      decryp = "";
      getError(ex);
    }
    return decryp;
  }

  // You will need a key to decrypt things and so on.
  Future<String> generateRandomKey() => _crypto.generateRandomKey();
}
