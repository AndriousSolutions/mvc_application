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
///          Created  18 Dec 2018
///
///

import 'package:mvc_application/view.dart'
    show GlobalKey, Prefs, ScaffoldState, StateMVC, unawaited;

import '../controller.dart' show AppController;

/// The Controller talks to the Model
import '../model.dart' show Contact, ContactsDB;

class Controller extends AppController {
  //
  factory Controller([StateMVC state]) => _this ??= Controller._(state);

  Controller._([StateMVC state])
      : model = ContactsDB(),
        super(state);
  final ContactsDB model;
  static Controller _this;

  static bool _sortedAlpha;
  static const String _SORT_KEY = 'sort_by_alpha';

  @override
  Future<bool> initAsync() async {
    _sortedAlpha = Prefs.getBool(_SORT_KEY, false);
    final bool init = await model.initState();
    if (init) {
      await getContacts();
    }
    return init;
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  Future<List<Contact>> getContacts() async {
    _contacts = await model.getContacts();
    if (_sortedAlpha) {
      _contacts.sort();
    }
    return _contacts;
  }

  @override
  Future<void> refresh() async {
    await getContacts();
    super.refresh();
  }

  /// Called by menu option
  Future<List<Contact>> sort() async {
    _sortedAlpha = !_sortedAlpha;
    await Prefs.setBool(_SORT_KEY, _sortedAlpha);
    unawaited(refresh());
    return _contacts;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Contact> get items => _contacts;
  List<Contact> _contacts;

  Contact itemAt(int index) => items?.elementAt(index);

  Future<bool> deleteItem(int index) async {
    final Contact contact = items?.elementAt(index);
    final delete = await contact.delete();
    await refresh();
    return delete;
  }
}
