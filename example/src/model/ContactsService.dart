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
///          Created  18 Dec 2018
///
///
import 'dart:async' show Future;

import 'dart:core'
    show Future, List, Map, MapEntry, String, bool, dynamic, int, override;

import 'package:sqflite/sqflite.dart' show Database;

import 'package:mvc_application/model.dart' show DBInterface;

import '../../model.dart' show Contact;

import '../../view.dart' show Item;

class ContactsService extends DBInterface {
  factory ContactsService() {
    _this ??= ContactsService._();
    return _this;
  }

  /// Make only one instance of this class.
  static ContactsService _this;

  /// Allow for easy access to this class throughout the application.
  static ContactsService get mod => _this ?? ContactsService();

  ContactsService._() : super();

  @override
  get name => 'Contacts';

  @override
  get version => 1;

  static Future<bool> initState() => ContactsService().init();

  static void dispose() {
    ContactsService().disposed();
  }

  Future onConfigure(Database db) {
    return db.execute("PRAGMA foreign_keys=ON;");
  }

  @override
  Future onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE Contacts(
              id INTEGER PRIMARY KEY
              ,displayName TEXT
              ,givenName TEXT
              ,middleName TEXT
              ,prefix TEXT
              ,suffix TEXT
              ,familyName TEXT
              ,company TEXT
              ,jobTitle TEXT
              ,deleted INTEGER DEFAULT 0
              )
     """);
//               ,FOREIGN KEY (userid) REFERENCES Contacts (id)
    await db.execute("""
     CREATE TABLE Emails(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,label TEXT
              ,email TEXT
              ,deleted INTEGER DEFAULT 0
              ,FOREIGN KEY (userid) REFERENCES Contacts (id)
              )
     """);

    await db.execute("""
     CREATE TABLE Phones(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,label TEXT
              ,phone TEXT
              ,deleted INTEGER DEFAULT 0
              )
     """);

    await db.execute("""
     CREATE TABLE Addresses(
              id INTEGER PRIMARY KEY
              ,userid INTEGER
              ,label TEXT
              ,address TEXT
              ,deleted INTEGER DEFAULT 0
              )
     """);
  }

  static Future<List<Contact>> getContacts() async {
    return listContacts(
        await _this.rawQuery('SELECT * FROM Contacts WHERE deleted = 0'));
  }

  static Future<List<Contact>> listContacts(
      List<Map<String, dynamic>> query) async {
    List<Contact> contactList = [];
    for (Map contact in query) {
      Map<String, dynamic> map = contact.map((key, value) {
        return MapEntry(key, value is int ? value?.toString() : value);
      });
      Contact aContact = Contact.fromMap(map);
      List<Map<String, dynamic>> phones = await _this.rawQuery(
          'SELECT * FROM Phones WHERE userid = ${contact['id']} AND deleted = 0');
      aContact.phones =
          phones.map((m) => Item.fromMap(m, 'label', 'phone')).toList();
      List<Map<String, dynamic>> emails = await _this.rawQuery(
          'SELECT * FROM Emails WHERE userid = ${contact['id']} AND deleted = 0');
      aContact.emails =
          emails.map((m) => Item.fromMap(m, 'label', 'email')).toList();
      List<Map<String, dynamic>> addresses = await _this.rawQuery(
          'SELECT * FROM Addresses WHERE userid = ${contact['id']} AND deleted = 0');
//      aContact.postalAddresses = addresses.map((m) => Item.fromMap(m));
      contactList.add(aContact);
    }
    return contactList;
  }

  static Future<bool> addContact(Map<String, dynamic> contact) async {
    Map<String, dynamic> rec = await _this.saveMap('Contacts', contact);
    if (rec.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map.addAll({'userid': contact['id']});
      for (Map phone in contact['phones']) {
        map.addAll(phone);
      }
      if (map.length > 1) rec = await _this.saveMap('Phones', map);
    }
    if (rec.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map.addAll({'userid': contact['id']});
      for (Map email in contact['emails']) {
        map.addAll(email);
      }
      if (map.length > 1) rec = await _this.saveMap('Emails', map);
    }
//       await _this.saveMap('addresses', contact['postalAddresses']);
    return rec.isNotEmpty;
//   });
  }

  static func(key, value) {}

  static Future<bool> deleteContact(Map contact) async {
    var id = contact['id'];
    if (id == null) return Future.value(false);
//    if (id is String) id = int.parse(id);
//    List<Map<String, dynamic>> query =
//        await _this.rawQuery('UPDATE Contacts SET deleted = 1 WHERE id = $id');
//    return query.length;
    Map<String, dynamic> rec = _this.newRec('Contacts', contact);
//    _this.addEntries('Contacts', rec);
    rec['deleted'] = 1;
    rec = await _this.saveMap('Contacts', rec);
    return rec.isNotEmpty;

//    return _this.delete('Contacts', id);
  }

  static Future<int> undeleteContact(Map contact) async {
    var id = contact['id'];
    if (id == null) return Future.value(0);
    if (id is String) id = int.parse(id);
    List<Map<String, dynamic>> query =
        await _this.rawQuery('UPDATE Contacts SET deleted = 0 WHERE id = $id');
    return query.length;
//    return _this.delete('Contacts', id);
  }
}
