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

import 'package:flutter/material.dart' show FlutterError, FlutterErrorDetails;

import 'package:mvc_application/view.dart' show Prefs;

/// The Controller talks to the Model
import '../../model.dart'
    show Contact, ContactAdd, ContactEdit, ContactList;

import '../../controller.dart' show ControllerMVC;

class Controller extends ControllerMVC {
  factory Controller() =>  _this ??= Controller._();
  static Controller _this;
  static bool _sortedAlpha;
  static const String _SORT_KEY = 'sort_by_alpha';

  Controller._() : super();

  @override
  void initState() {
//    ContactsService.initState();
    _sortedAlpha = Prefs.getBool(_SORT_KEY, false);
    list.refresh();
  }

  @override
  void dispose() {
    disposed();
    super.dispose();
  }

  static void disposed() {} //=> ContactsService.dispose();

  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);

  static Future<List<Contact>> getContacts() async {
    final contacts = []; //await ContactsService.getContacts();
    if (_sortedAlpha){ contacts.sort();}
    return contacts;
  }

  static Future<List<Contact>> sort() async {
    _sortedAlpha = !_sortedAlpha;
    await Prefs.setBool(_SORT_KEY, _sortedAlpha);
    final contacts = await getContacts();
    return contacts;
  }

  static ContactAdd get add => _addContacts;
  static ContactAdd _addContacts = ContactAdd();

  static ContactEdit get edit => _editContacts;
  static ContactEdit _editContacts = ContactEdit();

  static ContactList get list => _listContacts;
  static ContactList _listContacts = ContactList();

  Contact child(int index) {
    final contact = list.items?.elementAt(index);
    list.init(contact);
    return contact;
  }

  static Future<bool> delete(Object contact) async {
    if (contact is! Contact){ return Future.value(false);}
    bool delete = await edit.delete(contact as Contact);
    return delete;
  }
}
