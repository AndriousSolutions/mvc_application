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
///          Created  16 Dec 2018
///
///

import '../../controller.dart';

import '../../view.dart'
    show AppStatefulWidget, AppState, AddContact, BuildContext, ContactsList, Key;

class MyApp extends AppStatefulWidget {
  MyApp({Key key, this.rootKey}) : super(key: key);
  final Key rootKey;
  @override
  AppState createView() => ContactsExampleApp(key: rootKey);
}

class ContactsExampleApp extends AppState {
  ContactsExampleApp({Key key})
      : super(
            key: key,
            con: Controller(),
            title: 'Contacts Example',
            routes: {'/add': (BuildContext context) => const AddContact()},
            debugShowCheckedModeBanner: false,
            home: const ContactsList());
}
