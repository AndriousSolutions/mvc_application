import 'dart:async' show Future;

///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  11 May 2018
///
import 'dart:io' show File;

import 'package:uuid/uuid.dart' show Uuid;

import 'files.dart' show Files;

/// Introduces a 'install file' unique to the app.
class InstallFile {
  /// The name of the 'install file.'
  static const String FILE_NAME = '.install';

  /// The unique Id cotained with the 'install file.'
  static String? sID;

  static bool _justInstalled = false;

  /// Indicate if this is the 'first' install of the app.
  bool get justInstalled => _justInstalled;

  /// Return the unique identifier for this app installation.
  static Future<String?> id() async {
    if (sID != null) {
      return sID;
    }

    final installFile = await Files.get(FILE_NAME);

    try {
      // ignore: avoid_slow_async_io
      final exists = await installFile.exists();

      if (!exists) {
        _justInstalled = true;

        sID = writeInstallationFile(installFile);
      } else {
        sID = await readInstallationFile(installFile);
      }
    } catch (ex) {
      sID = '';
    }

    return sID;
  }

  /// Returns the content of the 'install file.'
  /// Pass in a File object of the install file.
  static Future<String> readInstallationFile(File installFile) async {
    final file = await Files.get(FILE_NAME);

    final content = await Files.readFile(file);

    return content;
  }

  /// Write to the 'install file.'
  /// Pass in a File object representing the install file.
  static String writeInstallationFile(File file) {
    const uuid = Uuid();
    // Generate a v4 (random) id
    final id = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
    Files.writeFile(file, id);
    return id;
  }
}
