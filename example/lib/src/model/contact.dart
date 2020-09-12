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
        City,
        Company,
        Contact,
        Country,
        ContactsDB,
        DisplayName,
        Email,
        FamilyName,
        GivenName,
        Id,
        JobTitle,
        MiddleName,
        Phone,
        PostalAddress,
        Postcode,
        Prefix,
        Region,
        Street,
        Suffix;

import '../view.dart' show App, DataFieldItem, MapClass, StateGetter;

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

  final PostalAddress _address = PostalAddress(label: '');

  GlobalKey<FormState> get formKey {
    if (!_inForm) {
      _inForm = true;
    }
    return _formKey;
  }

  bool _inForm = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool onPressed([BuildContext context]) {
    if (!_formKey.currentState.validate()) {
      return false;
    }
    _formKey.currentState.save();
    _inForm = false;
//    _contact.postalAddresses = [_address];
    // ignore: cascade_invocations

    add();

    return true;
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
  ContactList() : super();

//  Contact _contact;

  List<DataFieldItem> _emails, _phones;

  //  set email(String email) => [Item(label: "work", value: email)];
  List<PostalAddress> postalAddresses;

  void populate([Map<String, dynamic> map]) {
    final ma = MapClass(map);

    _id = Id(ma.p('id'));
    _givenName = GivenName(ma.p('givenName'));
    _middleName = MiddleName(ma.p('middleName'));
    _familyName = FamilyName(ma.p('familyName'));

    _displayName = DisplayName('${_givenName.value} ${_familyName.value}');

    _prefix = Prefix(ma.p('prefix'));
    _suffix = Suffix(ma.p('suffix'));
    _company = Company(ma.p('company'));
    _jobTitle = JobTitle(ma.p('jobTitle'));
    _phone = Phone(ma.p('phones'));
    _email = Email(ma.p('emails'));
    _street = Street(ma.p('street'));
    _city = City(ma.p('city'));
    _region = Region(ma.p('region'));
    _postcode = Postcode(ma.p('postcode'));
    _country = Country(ma.p('country'));
    // items = m['postalAddresses'];
    // postalAddresses = items?.map((m) => PostalAddress.fromMap(m));
    //postalAddresses = m['postalAddresses'];
  }

  Map<String, dynamic> get toMap {
    //
    final List<Map<String, dynamic>> emailList = email.mapItems<Email>(
      'Email',
      'email',
      _emails,
    );

    final List<Map<String, dynamic>> phoneList = phone.mapItems<Phone>(
      'Phone',
      'phone',
      _phones,
    );

    final List<Map<String, dynamic>> addressList = [];

    for (final address in postalAddresses ?? []) {
      addressList.add(address.toMap);
    }

    return {
      'id': _id.value,
      'displayName': _displayName.value,
      'givenName': _givenName.value,
      'middleName': _middleName.value,
      'familyName': _familyName.value,
      'prefix': _prefix.value,
      'suffix': _suffix.value,
      'company': _company.value,
      'jobTitle': _jobTitle.value,
      'emails': emailList,
      'phones': phoneList,
      'postalAddresses': addressList,
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
      _prefix,
      _suffix,
      _company,
      _jobTitle,
      _phone,
      _email,
      _street,
      _city,
      _region,
      _postcode,
      _country;

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

  Prefix get prefix => _prefix;
  set prefix(Prefix prefix) => _prefix = prefix;

  Suffix get suffix => _suffix;
  set suffix(Suffix suffix) => _suffix = suffix;

  Company get company => _company;
  set company(Company company) => _company = company;

  JobTitle get jobTitle => _jobTitle;
  set jobTitle(JobTitle job) => _jobTitle = job;

  Phone get phone => _phone;
  set phone(Phone phone) => _phone = phone;

  Email get email => _email;
  set email(Email email) => _email = email;

  Street get street => _street;
  set street(Street street) => _street = email;

  City get city => _city;
  set city(City city) => _city = city;

  Region get region => _region;
  set region(Region region) => _region = region;

  Postcode get postcode => _postcode;
  set postcode(Postcode postcode) => _postcode = postcode;

  Country get country => _country;
  set country(Country country) => _country = country;
}
