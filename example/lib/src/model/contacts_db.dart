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
import 'dart:async' show Future;

import 'dart:core'
    show Future, List, Map, MapEntry, String, bool, dynamic, int, override;

import 'package:dbutils/sqlite_db.dart';

import '../model.dart' show Contact;

import '../view.dart' show DataFieldItem;

class ContactsDB extends SQLiteDB {
  factory ContactsDB() => _this ??= ContactsDB._();
  ContactsDB._() : super();

  /// Make only one instance of this class.
  static ContactsDB _this;

  @override
  String get name => 'Contacts';

  @override
  int get version => 1;

  Future<bool> initState() => init();

  void dispose() => disposed();

  @override
  Future<void> onConfigure(Database db) {
    return db.execute('PRAGMA foreign_keys=ON;');
  }

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.transaction((Transaction txn) async {
      await txn.execute('''
     CREATE TABLE Contacts(
              id INTEGER PRIMARY KEY
              ,givenName TEXT
              ,middleName TEXT
              ,familyName TEXT
              ,company TEXT
              ,jobTitle TEXT
              ,deleted INTEGER DEFAULT 0
              )
     ''');

      await txn.execute('''
     CREATE TABLE Emails(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,type TEXT
              ,email TEXT
              ,deleted INTEGER DEFAULT 0
              ,FOREIGN KEY (userid) REFERENCES Contacts (id)
              )
     ''');

      await txn.execute('''
     CREATE TABLE Phones(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,type TEXT
              ,phone TEXT
              ,deleted INTEGER DEFAULT 0
              )
     ''');
    }, exclusive: true);
  }

  Future<List<Contact>> getContacts() async {
    return listContacts(
        await _this.rawQuery('SELECT * FROM Contacts WHERE deleted = 0'));
  }

  Future<List<Contact>> listContacts(List<Map<String, dynamic>> query) async {
    //
    final contactList = <Contact>[];

    for (final contact in query) {
      //
      final map = contact.map((key, value) {
        return MapEntry(key, value is int ? value?.toString() : value);
      });

      final phones = await _this.rawQuery(
          'SELECT * FROM Phones WHERE userid = ${contact['id']} AND deleted = 0');

      map['phones'] =
          phones.map((m) => DataFieldItem.fromMap(m, value: 'phone')).toList();

      final emails = await _this.rawQuery(
          'SELECT * FROM Emails WHERE userid = ${contact['id']} AND deleted = 0');

      map['emails'] =
          emails.map((m) => DataFieldItem.fromMap(m, value: 'email')).toList();

      final _contact = Contact.fromMap(map);

      contactList.add(_contact);
    }

    return contactList;
  }

  Future<bool> addContact(Contact contact) async {
    //
    var add = true;

    final map = contact.toMap;

    // The Contact's unique id
    dynamic id = map['id'];

    if (contact.isChanged()) {
      //
      final newContact = await _this.saveMap('Contacts', map);

      id ??= newContact['id'];

      add = newContact.isNotEmpty;
    }

    // Save Phone Numbers
    if (add && contact.phoneChange()) {
      //
      for (final Map<String, dynamic> phone in map['phones']) {
        //
        if (phone.isEmpty) {
          continue;
        }

        phone.addAll({'userid': id});

        await _this.saveMap('Phones', phone);
      }
    }

    if (add && contact.emailChange()) {
      // Save Emails.
      for (final Map<String, dynamic> email in map['emails']) {
        //
        if (email.isEmpty) {
          continue;
        }

        email.addAll({'userid': id});

        await _this.saveMap('Emails', email);
      }
    }
    return add;
  }

  void func(key, value) {}

  Future<bool> deleteContact(Contact contact) async {
    //
    final map = contact.toMap;
    //
    final id = map['id'];

    if (id == null) {
      return Future.value(false);
    }

    Map<String, dynamic> rec;

    rec = _this.newRec('Contacts', map);

    rec['deleted'] = 1;

    rec = await _this.saveMap('Contacts', rec);

    if (rec.isNotEmpty) {
      //
      for (final Map<String, dynamic> phone in map['phones']) {
        //
        rec = _this.newRec('Phones', phone);

        rec['deleted'] = 1;

        await _this.saveMap('Phones', rec);
      }

      for (final Map<String, dynamic> email in map['emails']) {
        //
        rec = _this.newRec('Emails', email);

        rec['deleted'] = 1;

        await _this.saveMap('Emails', rec);
      }
    }

    return rec.isNotEmpty;
  }

  Future<int> undeleteContact(Contact contact) async {
    //
    final map = contact.toMap;

    var id = map['id'];

    if (id == null) {
      return Future.value(0);
    }

    if (id is String) {
      id = int.parse(id);
    }

    var query =
        await _this.rawQuery('UPDATE Contacts SET deleted = 0 WHERE id = $id');
    final rec = query.length;

    if (rec > 0) {
      query =
          await _this.rawQuery('UPDATE Phones SET deleted = 0 WHERE id = $id');

      query =
          await _this.rawQuery('UPDATE Emails SET deleted = 0 WHERE id = $id');
    }
    return rec;
  }
}
