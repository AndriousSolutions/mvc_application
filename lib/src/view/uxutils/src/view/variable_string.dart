// ignore: avoid_classes_with_only_static_members
///
/// Copyright (C) 2019 Andrious Solutions
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
///          Created  14 Nov 2019
///
///

class VarStr {
  static final VariableString _varStr = VariableString();

  /// Set a String value to the Variable String object.
  static String set(String str) => _varStr.value = str;

  /// Return the Variable String Object's value.
  static String get get => _varStr.value;
}

/// Variable String Clas
class VariableString {
  /// Variable String Constructor.
  VariableString() {
    regExp = RegExp("'(.*?)'");
  }

  /// Reg Expression.
  late RegExp regExp;

  String _value = '';

  set value(String? str) {
    _value = '';
    if (str != null && str.isNotEmpty) {
      final match = regExp.firstMatch(str);
      if (match != null) {
        _value = match.group(0)!.replaceAll("'", '');
      }
    }
  }

  /// Return the Variable String Object's value.
  String get value => _value;
}
