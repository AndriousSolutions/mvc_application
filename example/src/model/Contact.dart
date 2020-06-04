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

import 'package:flutter/material.dart';

import '../../model.dart' show PostalAddress;

import '../../view.dart' show FieldWidgets, DataFieldItem;

class Contact<E> implements Comparable<Contact> {
  Contact();

  Contact.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
//    emails = (m["emails"] as Iterable)?.map((m) => Item.fromMap(m));
//    phones = (m["phones"] as Iterable)?.map((m) => Item.fromMap(m));
//    postalAddresses = (m["postalAddresses"] as Iterable)
//        ?.map((m) => PostalAddress.fromMap(m));
  }

  String _id,
      _prefix,
      _suffix,
      _company,
      _jobTitle,
      _displayName,
      _givenName,
      _middleName,
      _familyName,
      _phone,
      _email,
      _street,
      _city,
      _region,
      _postcode,
      _country;

  List<DataFieldItem> emails, phones;
  //  set email(String email) => [Item(label: "work", value: email)];
  List<PostalAddress> _postalAddresses;

  Map<String, dynamic> get toMap {
    var emailList = [];
    var phoneList = [];

    if (emails == null) {
      emails = [];
      if (_email != null && _email.isNotEmpty) {
        DataFieldItem item = DataFieldItem(label: "home", value: _email);
        item.keys('label', 'email');
        emails.add(item);
      }
    }
    for (DataFieldItem email in emails ?? []) {
      email.keys('label', 'email');
      emailList.add(email.toMap);
    }
    if (phones == null || phones.length == 0) {
      if (_phone != null && _phone.isNotEmpty) {
        phones = [];
        DataFieldItem item = DataFieldItem(label: "home", value: _phone);
        item.keys('label', 'phone');
        phones.add(item);
      }
    }
    for (DataFieldItem phone in phones ?? []) {
      phone.keys('label', 'phone');
      phoneList.add(phone.toMap);
    }
    var addressList = [];
    for (PostalAddress address in _postalAddresses ?? []) {
      addressList.add(address.toMap);
    }
    return {
      "id": _id,
      "displayName": _displayName,
      "givenName": _givenName,
      "middleName": _middleName,
      "familyName": _familyName,
      "prefix": _prefix,
      "suffix": _suffix,
      "company": _company,
      "jobTitle": _jobTitle,
      "emails": emailList,
      "phones": phoneList,
      "postalAddresses": addressList,
    };
  }

  String get id => _id;
  set id(String v) {
    if (v == null) v = "";
    _id = v;
  }

  String get displayName => _displayName;
  set displayName(String v) {
    if (v == null) v = "";
    _displayName = v;
  }

  String get givenName => _givenName;
  set givenName(String v) {
    if (v == null) v = "";
    _givenName = v;
    _nameDisplayed();
  }

  String get middleName => _middleName;
  set middleName(String v) {
    if (v == null) v = "";
    _middleName = v;
  }

  String get familyName => _familyName;
  set familyName(String v) {
    if (v == null) v = "";
    _familyName = v;
    _nameDisplayed();
  }

  void _nameDisplayed() {
    _displayName = givenName ?? " " + ' ' + familyName ?? " ";
  }

  String get prefix => _prefix;
  set prefix(String v) {
    if (v == null) v = "";
    _prefix = v;
  }

  String get suffix => _suffix;
  set suffix(String v) {
    if (v == null) v = "";
    _suffix = v;
  }

  String get company => _company;
  set company(String v) {
    if (v == null) v = "";
    _company = v;
  }

  String get jobTitle => _jobTitle;
  set jobTitle(String v) {
    if (v == null) v = "";
    _jobTitle = v;
  }

  String get phone => _phone;
  set phone(String v) {
    if (v == null) v = "";
    _phone = v;
  }

  String get email => _email;
  set email(String v) {
    if (v == null) v = "";
    _email = v;
  }

  List<PostalAddress> get postalAddresses => _postalAddresses;
  set postalAddresses(List<PostalAddress> address) {
    if (address == null) return;
    _postalAddresses = address;
  }

  String get street => _street;
  set street(String v) {
    if (v == null) v = "";
    _street = v;
  }

  String get city => _city;
  set city(String v) {
    if (v == null) v = "";
    _city = v;
  }

  String get region => _region;
  set region(String v) {
    if (v == null) v = "";
    _region = v;
  }

  String get postcode => _postcode;
  set postcode(String v) {
    if (v == null) v = "";
    _postcode = v;
  }

  String get country => _country;
  set country(String v) {
    if (v == null) v = "";
    _country = v;
  }

  int compareTo(Contact other) => _givenName.compareTo(other._givenName);
}

class Id extends FieldWidgets<Contact> {
  Id([Contact contact])
      : super(object: contact, label: 'Identifier', value: contact?.id);

  void onSaved(v) => object?.id = value = v;
}

class DisplayName extends FieldWidgets<Contact> {
  DisplayName([Contact contact])
      : super(
          object: contact,
          label: 'Display Name',
          value: contact?.displayName,
        );

  void onSaved(v) => object?.displayName = value = v;

  @override
  CircleAvatar get circleAvatar =>
      CircleAvatar(child: Text(value.length > 1 ? value?.substring(0, 2) : ""));
}

class GivenName extends FieldWidgets<Contact> {
  GivenName([Contact contact])
      : super(object: contact, label: 'First Name', value: contact?.givenName);

  void onSaved(v) => object?.givenName = value = v;
}

class MiddleName extends FieldWidgets<Contact> {
  MiddleName([Contact contact])
      : super(
            object: contact, label: 'Middle Name', value: contact?.middleName);

  void onSaved(v) => object?.middleName = value = v;
}

class FamilyName extends FieldWidgets<Contact> {
  FamilyName([Contact contact])
      : super(
          object: contact,
          label: 'Last Name',
          value: contact?.familyName,
        );

  void onSaved(v) => object?.familyName = value = v;
}

class Prefix extends FieldWidgets<Contact> {
  Prefix([Contact contact])
      : super(object: contact, label: 'Prefix', value: contact?.prefix);

  void onSaved(v) => object?.prefix = value = v;
}

class Suffix extends FieldWidgets<Contact> {
  Suffix([Contact contact])
      : super(object: contact, label: 'Suffix', value: contact?.suffix);

  void onSaved(v) => object?.suffix = value = v;
}

class Company extends FieldWidgets<Contact> {
  Company([Contact contact])
      : super(object: contact, label: 'Company', value: contact?.company);

  void onSaved(v) => object?.company = value = v;
}

class JobTitle extends FieldWidgets<Contact> {
  JobTitle([Contact contact])
      : super(object: contact, label: 'Job', value: contact?.jobTitle);

  void onSaved(v) => object?.jobTitle = value = v;
}

class Phone extends FieldWidgets<Contact> {
  Phone([Contact contact])
      : super(object: contact, label: 'Phone', value: contact?.phones) {
    // Change the name of the map's key fields.
    keys('label', 'phone');
  }

  Phone.single([Contact contact])
      : super(object: contact, label: 'Phone', value: contact?.phone) {
    // Change the name of the map's key fields.
    keys('label', 'phone');
  }
  void onSaved(v) {
    if (v == null) return;
    if (v is List<DataFieldItem>) {
      object?.phones = (v as List<DataFieldItem>);
      return;
    }
    if (v is String) {
      object?.phone = v;
      return;
    }
  }

  @override
  TextFormField get textFormField => TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (v) => onSaved(v),
      keyboardType: TextInputType.phone);
}

class Email extends FieldWidgets<Contact> {
  Email([Contact contact])
      : super(object: contact, label: 'E-mail', value: contact?.emails);

  Email.single([Contact contact])
      : super(object: contact, label: 'E-mail', value: contact?.email);

  void onSaved(v) {
    if (v == null) return;
    if (v is List<DataFieldItem>) {
      object?.emails = (v as List<DataFieldItem>);
      return;
    }
    if (v is String) {
      object?.email = v;
      return;
    }
  }

  @override
  TextFormField get textFormField => TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (v) => onSaved(v),
      keyboardType: TextInputType.emailAddress);
}

class Street extends FieldWidgets<Contact> {
  Street([Contact contact])
      : super(object: contact, label: 'Street', value: contact?.company);

  void onSaved(v) => object?.street = value = v;
}

class City extends FieldWidgets<Contact> {
  City([Contact contact])
      : super(object: contact, label: 'City', value: contact?.company);

  void onSaved(v) => object?.city = value = v;
}

class Region extends FieldWidgets<Contact> {
  Region([Contact contact])
      : super(object: contact, label: 'Region', value: contact?.company);

  void onSaved(v) => object?.region = value = v;
}

class Postcode extends FieldWidgets<Contact> {
  Postcode([Contact contact])
      : super(object: contact, label: 'Postal code', value: contact?.company);

  void onSaved(v) => object?.postcode = value = v;
}

class Country extends FieldWidgets<Contact> {
  Country([Contact contact])
      : super(object: contact, label: 'Country', value: contact?.company);

  void onSaved(v) => object?.country = value = v;
}
