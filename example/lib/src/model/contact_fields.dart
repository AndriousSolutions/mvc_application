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

//import 'package:flutter/material.dart';

import '../model.dart' show Contact, PostalAddress;

import '../view.dart';

/// Add to the class this:
/// `extends FieldWidgets<T> with FieldChange`
mixin FormFields on FieldWidgets<Contact> {
  //
  Set<FieldWidgets<Contact>> get changedFields => _changedFields;
  static final Set<FieldWidgets<Contact>> _changedFields = {};

  @override
  void onSaved(dynamic v) {
    super.onSaved(v);
    if(isChanged()){
      _changedFields.add(this);
    }
  }

  bool changeIn<T>() => changedFields.whereType<T>().isNotEmpty;
}

class Id extends FieldWidgets<Contact> with FormFields {
  Id(dynamic value) : super(label: 'Identifier', value: value);
}

String notEmpty(String v) => v.isEmpty ? 'Cannot be empty' : null;

class DisplayName extends FieldWidgets<Contact> with FormFields {
  DisplayName(dynamic value)
      : super(
          label: 'Display Name',
          value: value,
          child: Text(value ?? ''),
        );
}

class GivenName extends FieldWidgets<Contact> with FormFields {
  GivenName([dynamic value])
      : super(
          label: 'First Name',
          value: value,
          validator: notEmpty,
        );
}

class MiddleName extends FieldWidgets<Contact> with FormFields {
  MiddleName([dynamic value]) : super(label: 'Middle Name', value: value);
}

class FamilyName extends FieldWidgets<Contact> with FormFields {
  FamilyName([dynamic value])
      : super(
          label: 'Last Name',
          value: value,
          validator: notEmpty,
        );
}

class Prefix extends FieldWidgets<Contact> with FormFields {
  Prefix([dynamic value]) : super(label: 'Prefix', value: value);
}

class Suffix extends FieldWidgets<Contact> with FormFields {
  Suffix([dynamic value]) : super(label: 'Suffix', value: value);
}

class Company extends FieldWidgets<Contact> with FormFields {
  Company([dynamic value]) : super(label: 'Company', value: value);
}

class JobTitle extends FieldWidgets<Contact> with FormFields {
  JobTitle([dynamic value]) : super(label: 'Job', value: value);
}

class Phone extends FieldWidgets<Contact> with FormFields {
  //
  Phone([dynamic value])
      : super(
          label: 'Phone',
          value: value,
          inputDecoration: const InputDecoration(labelText: 'Phone'),
          keyboardType: TextInputType.phone,
        ) {
    // Change the name of the map's key fields.
    keys(value: 'phone');
    phone2Phones();
  }

  void phone2Phones() {
    if (value is! List<DataFieldItem>) {
      return;
    }
    final List<DataFieldItem> items = value;
    value = null;
    final List<Phone> phones = [];

    for (final DataFieldItem item in items) {
      final phone = Phone(item.value)
        ..label = item.label
        ..id = item.id
        ..initialValue = item.value;
      phones.add(phone);
    }
    this.items = phones;
  }

  State get state {
    final Contact con = object;
    // Call its getter
    return con?.state;
  }

  @override
  void onChanged(String value) {
    super.onChanged(value);
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  @override
  ListItems<Contact> onListItems({
    String title,
    List<FieldWidgets<Contact>> items,
    MapItemFunction mapItem,
    GestureTapCallback onTap,
    List<String> dropItems,
  }) =>
      super.onListItems(
        title: title,
        items: items,
        mapItem: mapItem,
        onTap: onTap,
        dropItems:
            dropItems ?? const ['home', 'work', 'landline', 'modile', 'other'],
      );
}

class Email extends FieldWidgets<Contact> with FormFields {
  Email([dynamic value])
      : super(
          label: 'Email',
          value: value,
          inputDecoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ) {
    email2Emails();
  }

  /// Convert a list item into separate Email objects.
  void email2Emails() {
    if (value is! List<DataFieldItem>) {
      return;
    }
    final List<DataFieldItem> items = value;
    value = null;
    final List<Email> emails = [];

    for (final DataFieldItem item in items) {
      final email = Email(item.value)
        ..label = item.label
        ..id = item.id
        ..initialValue = item.value;
      emails.add(email);
    }
    this.items = emails;
  }

  @override
  ListItems<Contact> onListItems({
    String title,
    List<FieldWidgets<Contact>> items,
    MapItemFunction mapItem,
    GestureTapCallback onTap,
    List<String> dropItems,
  }) =>
      super.onListItems(
        title: title,
        items: items,
        mapItem: mapItem,
        onTap: onTap,
        dropItems: dropItems ?? ['home', 'work', 'other'],
      );
}

// @override
// TextFormField get textFormField => TextFormField(
//     decoration: InputDecoration(labelText: label),
//     onSaved: onSaved,
//     keyboardType: TextInputType.emailAddress);
// }

class Street extends FieldWidgets<Contact> with FormFields {
  Street([dynamic value]) : super(label: 'Street', value: value);
}

class City extends FieldWidgets<Contact> with FormFields {
  City([dynamic value]) : super(label: 'City', value: value);
}

class Region extends FieldWidgets<Contact> with FormFields {
  Region([dynamic value]) : super(label: 'Region', value: value);
}

class Postcode extends FieldWidgets<Contact> with FormFields {
  Postcode([dynamic value]) : super(label: 'Postal code', value: value);
}

class Country extends FieldWidgets<Contact> with FormFields {
  Country([dynamic value]) : super(label: 'Country', value: value);
}
