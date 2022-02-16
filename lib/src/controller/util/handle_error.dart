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
mixin HandleError {
  /// Return the 'last' error if any.
  Exception? getError([dynamic error]) {
    var ex = _error;
    if (error == null) {
      _error = null;
    } else {
      if (error is! Exception) {
        _error = Exception(error.toString());
      } else {
        _error = error;
      }
      ex ??= _error;
    }
    return ex;
  }

  /// Simply display the error.
  String get errorMsg => _error == null ? '' : _error.toString();

  /// Indicate if app is 'in error.'
  bool get inError => _error != null;

  /// Indicate if the app is 'in error.'
  bool get hasError => _error != null;
  Exception? _error;
}
