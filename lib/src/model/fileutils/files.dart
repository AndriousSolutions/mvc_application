///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  11 May 2018
///
import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class Files {
  static String _path;

  static Future<String> get localPath async {
    if (_path == null) {
      var directory = await getApplicationDocumentsDirectory();
      _path = directory.path;
    }
    return _path;
  }

  static Future<String> read(String fileName) async {
    var file = await get(fileName);

    return readFile(file);
  }

  static Future<String> readFile(File file) async {
    String contents;

    try {
      // Read the file
      contents = await file.readAsString();
    } catch (e) {
      // If we encounter an error
      contents = '';
    }
    return contents;
  }

  static Future<File> write(String fileName, String content) async {
    var file = await get(fileName);
    // Write the file
    return writeFile(file, content);
  }

  static Future<File> writeFile(File file, String content) async {
    // Write the file
    return file.writeAsString(content, flush: true);
  }

  static Future<bool> exists(String fileName) async {
    var file = await get(fileName);
    return file.exists();
  }

  static Future<File> get(String fileName) async {
    var path = await localPath;
    return File('$path/$fileName');
  }
}
