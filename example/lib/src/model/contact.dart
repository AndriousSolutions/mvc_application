///
/// Copyright (C) 2019 Andrious Solutions
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
///          Created  30 Jan 2019
///
///

import 'package:flutter/material.dart' show BuildContext, GlobalKey, FormState;

import '../model.dart'
    show
        ContactsDB,
        DisplayName,
        GivenName,
        MiddleName,
        FamilyName,
        Phone,
        Email,
        Company,
        JobTitle,
        Id;

import '../view.dart' show DataFieldItem, MapClass, StateGetter;

import 'contact_fields.dart';

class Contact extends ContactEdit
    with StateGetter
    implements Comparable<Contact> {
  //
  Contact() {
    populate();
  }

  Contact.fromMap(Map<String, dynamic> map) {
    populate(map);
  }

  @override
  int compareTo(Contact other) =>
      _givenName.value.toString().compareTo(other._givenName.value.toString());
}

class ContactEdit extends ContactList {
  //
  ContactEdit() {
    model = ContactsDB();
  }
  ContactsDB model;

  GlobalKey<FormState> get formKey {
    if (!_inForm) {
      _inForm = true;
    }
    return _formKey;
  }

  bool _inForm = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> onPressed([BuildContext context]) async {
    if (!_formKey.currentState.validate()) {
      return false;
    }
    _formKey.currentState.save();
    _inForm = false;
    return add();
  }

  Future<bool> add() => model.addContact(this);

  Future<bool> delete() => model.deleteContact(this);

  Future<int> undelete() => model.undeleteContact(this);

  bool isChanged() => _givenName.changedFields
      .where((field) => field is! Phone && field is! Email)
      .isNotEmpty;

  bool phoneChange() => _givenName.changeIn<Phone>();

  bool emailChange() => _givenName.changeIn<Email>();
}

class ContactList extends ContactFields {
  //
  List<DataFieldItem> _emails, _phones;

  void populate([Map<String, dynamic> map]) {
    //
    final ma = MapClass(map);

    _id = Id(ma.p('id'));
    _givenName = GivenName(ma.p('givenName'));
    _middleName = MiddleName(ma.p('middleName'));
    _familyName = FamilyName(ma.p('familyName'));

    _displayName = DisplayName(this);
    _company = Company(ma.p('company'));
    _jobTitle = JobTitle(ma.p('jobTitle'));
    _phone = Phone(ma.p('phones'), this);
    _email = Email(ma.p('emails'), this);
  }

  Map<String, dynamic> get toMap {
    //
    final List<Map<String, dynamic>> emailList = email.mapItems<Email>(
      'email',
      _emails,
      (data) => Email.init(data),
    );

    final List<Map<String, dynamic>> phoneList = phone.mapItems<Phone>(
      'phone',
      _phones,
      (data) => Phone.init(data),
    );

    return {
      'id': _id.value,
      'displayName': _displayName.value,
      'givenName': _givenName.value,
      'middleName': _middleName.value,
      'familyName': _familyName.value,
      'emails': emailList,
      'phones': phoneList,
      'company': _company.value,
      'jobTitle': _jobTitle.value,
    };
  }
}

class ContactFields {
  //
  FormFields _id,
      _displayName,
      _givenName,
      _middleName,
      _familyName,
      _phone,
      _email,
      _company,
      _jobTitle;

  Id get id => _id;
  set id(Id id) => _id = id;

  DisplayName get displayName => _displayName;
  set displayName(DisplayName name) => _displayName = name;

  GivenName get givenName => _givenName;
  set givenName(GivenName name) => _givenName = name;

  MiddleName get middleName => _middleName;
  set middleName(MiddleName name) => _middleName = name;

  FamilyName get familyName => _familyName;
  set familyName(FamilyName name) => _familyName = name;

  Company get company => _company;
  set company(Company company) => _company = company;

  JobTitle get jobTitle => _jobTitle;
  set jobTitle(JobTitle job) => _jobTitle = job;

  Phone get phone => _phone;
  set phone(Phone phone) => _phone = phone;

  Email get email => _email;
  set email(Email email) => _email = email;
}
