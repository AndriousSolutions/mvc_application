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
///          Created  31 Mar 2020
///
///

import 'package:flutter_string_encryption/flutter_string_encryption.dart'
    show PlatformStringCryptor;

class StringCrypt {
  StringCrypt({
    String key,
    String password,
    String salt,
  }) {
    if (key != null && key.trim().isNotEmpty) {
      _key = key;
    } else {
      _keyFromPassword(password, salt).then((String key) {
        _key = key;
      });
    }
  }
  String _key;
  static PlatformStringCryptor _crypto = PlatformStringCryptor();

  Future<String> en(String data, [String key]) => encrypt(data, key);

  Future<String> encrypt(String data, [String key]) async {
    if (key != null) {
      key = key.trim();
      if (key.isEmpty) key = null;
    }
    String encrypt;
    try {
      encrypt = await _crypto.encrypt(data, key ??= _key);
    } catch (ex) {
      encrypt = "";
      getError(ex);
    }
    return encrypt;
  }

  Future<String> de(String data, [String key]) => decrypt(data, key);

  Future<String> decrypt(String data, [String key]) async {
    if (key != null) {
      key = key.trim();
      if (key.isEmpty) key = null;
    }
    String decrypt;
    try {
      decrypt = await _crypto.decrypt(data, key ??= _key);
    } catch (ex) {
      decrypt = "";
      getError(ex);
    }
    return decrypt;
  }

  // You will need a key to decrypt things and so on.
  static Future<String> generateRandomKey() => _crypto.generateRandomKey();

  // Generates a salt to use with [generateKeyFromPassword]
  static Future<String> generateSalt() => _crypto.generateSalt();

  // Gets a key from the given [password] and [salt].
  static Future<String> generateKeyFromPassword(String password, String salt) =>
      _crypto.generateKeyFromPassword(password, salt);

  Future<String> _keyFromPassword(String password, String salt) async {
    if (password == null || password.trim().isEmpty) return "";
    String _salt;
    if (salt == null || salt.trim().isEmpty) {
      _salt = await generateSalt();
    } else {
      _salt = salt.trim();
    }
    return await generateKeyFromPassword(password, _salt);
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
