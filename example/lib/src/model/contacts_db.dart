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

import 'package:contacts_example/src/model/postal_address.dart';
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
              ,prefix TEXT
              ,suffix TEXT
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
              ,label TEXT
              ,email TEXT
              ,deleted INTEGER DEFAULT 0
              ,FOREIGN KEY (userid) REFERENCES Contacts (id)
              )
     ''');

      await txn.execute('''
     CREATE TABLE Phones(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,label TEXT
              ,phone TEXT
              ,deleted INTEGER DEFAULT 0
              )
     ''');

      await txn.execute('''
     CREATE TABLE Addresses(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,label TEXT
              ,address TEXT
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
    final List<Contact> contactList = [];

    for (final Map<String, dynamic> contact in query) {
      final Map<String, dynamic> map = contact.map((key, value) {
        return MapEntry(key, value is int ? value?.toString() : value);
      });

      final List<Map<String, dynamic>> phones = await _this.rawQuery(
          'SELECT * FROM Phones WHERE userid = ${contact['id']} AND deleted = 0');

      map['phones'] =
          phones.map((m) => DataFieldItem.fromMap(m, value: 'phone')).toList();

      final List<Map<String, dynamic>> emails = await _this.rawQuery(
          'SELECT * FROM Emails WHERE userid = ${contact['id']} AND deleted = 0');

      map['emails'] =
          emails.map((m) => DataFieldItem.fromMap(m, value: 'email')).toList();

      final List<Map<String, dynamic>> addresses = await _this.rawQuery(
          'SELECT * FROM Addresses WHERE userid = ${contact['id']} AND deleted = 0');

      map['postalAddresses'] = addresses
          .map<PostalAddress>((m) => PostalAddress.fromMap(m))
          .toList();

      final Contact _contact = Contact.fromMap(map);

      contactList.add(_contact);
    }

    return contactList;
  }

  Future<bool> addContact(Contact contact) async {
    //
    bool add = true;

    final Map<String, dynamic> map = contact.toMap;

    if (contact.isChanged()) {
      //
      final rec = await _this.saveMap('Contacts', map);

      add = rec.isNotEmpty;
    }

    // Save Phone Numbers
    if (add && contact.phoneChange()) {
      //
      for (final Map<String, dynamic> phone in map['phones']) {
        //
        if (phone.isEmpty) {
          continue;
        }

        phone.addAll({'userid': map['id']});

        final rec = await _this.saveMap('Phones', phone);

        if (rec.isEmpty) {}
      }
    }

    // Save Phone Numbers
    if (add && contact.emailChange()) {
      // Save Emails.
      for (final Map<String, dynamic> email in map['emails']) {
        //
        if (email.isEmpty) {
          continue;
        }

        email.addAll({'userid': map['id']});

        final rec = await _this.saveMap('Emails', email);

        if (rec.isEmpty) {}
      }
    }
    return add;
  }

  void func(key, value) {}

  Future<bool> deleteContact(Contact contact) async {
    //
    final Map<String, dynamic> map = contact.toMap;
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
      rec = _this.newRec('Phones', map['phones']);

      rec['deleted'] = 1;

      await _this.saveMap('Phones', rec);

      rec = _this.newRec('Emails', map['emails']);

      rec['deleted'] = 1;

      await _this.saveMap('Emails', rec);
    }

    return rec.isNotEmpty;
  }

  Future<int> undeleteContact(Contact contact) async {
    //
    final Map<String, dynamic> map = contact.toMap;

    var id = map['id'];

    if (id == null) {
      return Future.value(0);
    }

    if (id is String) {
      id = int.parse(id);
    }

    List<Map<String, dynamic>> query =
        await _this.rawQuery('UPDATE Contacts SET deleted = 0 WHERE id = $id');
    final int rec = query.length;

    if (rec > 0) {
      query =
          await _this.rawQuery('UPDATE Phones SET deleted = 0 WHERE id = $id');

      query =
          await _this.rawQuery('UPDATE Emails SET deleted = 0 WHERE id = $id');
    }
    return rec;
  }
}
