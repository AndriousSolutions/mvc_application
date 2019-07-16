///
/// Copyright (C) 2019 Andrious Solutions
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
///          Created  09 Mar 2019
///
///

import "dart:async" show Future;

import 'package:flutter/material.dart'
    show AssetImage, BuildContext, DefaultAssetBundle;

import 'package:flutter/services.dart' show AssetBundle, ByteData;

class Assets {
  static Future<bool> init(BuildContext context, {String dir}) {
    if (_assets == null) {
      _assets = DefaultAssetBundle.of(context);
      _dir = dir ?? 'assets';
    }
    return Future.value(true);
  }

  static AssetBundle _assets;
  static String _dir;

  static dispose() {
    _assets = null;
  }

  static Future<ByteData> getStreamF(String key) async {
    assert(Assets._assets != null, 'Assets.init() must be called first.');
    ByteData data;
    try {
      data = await Assets._assets.load("$setPath(key)$key");
    } catch (ex) {
      data = ByteData(0);
    }
    return data;
  }

  static Future<String> getStringF(String key, {bool cache = true}) async {
    assert(Assets._assets != null, 'Assets.init() must be called first.');
    String asset;
    try {
      asset =
          await Assets._assets.loadString("$setPath(key)$key", cache: cache);
    } catch (ex) {
      asset = '';
    }
    return asset;
  }

  Future<T> getData<T>(String key, Future<T> parser(String value)) async {
    assert(Assets._assets != null, 'Assets.init() must be called first.');
    Future<T> data;
    try {
      data = Assets._assets.loadStructuredData("$setPath(key)$key", parser);
    } catch (ex) {
      data = null;
    }
    return data;
  }

  Future<String> getStringData(
      String key, Future<String> parser(String value)) async {
    assert(Assets._assets != null, 'Assets.init() must be called first.');
    String data;
    try {
      data =
          await Assets._assets.loadStructuredData("$setPath(key)$key", parser);
    } catch (ex) {
      data = null;
    }
    return data;
  }

  Future<bool> getBoolData(
      String key, Future<bool> parser(String value)) async {
    assert(Assets._assets != null, 'Assets.init() must be called first.');
    bool data;
    try {
      data =
          await Assets._assets.loadStructuredData("$setPath(key)$key", parser);
    } catch (ex) {
      data = false;
    }
    return data;
  }

  AssetImage getImage(String key, {AssetBundle bundle, String package}) {
    return AssetImage(key, bundle: bundle, package: package);
  }

  /// Determine the appropriate path for the asset.
  static String setPath(String key) {
    /// In case 'assets' begins the key or if '/' begins the key.
    var path = key.indexOf(_dir) == 0
        ? ''
        : key.substring(0, 0) == '/' ? _dir : "$_dir/";
    return path;
  }
}

/// Saved for the Testing code to work.
/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
