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
///          Created  19 Dec 2018
///
///

import 'package:flutter/material.dart';

typedef OnSavedFunc = Function<E>(E v);

abstract class Field<T> extends Item {
  Field({this.object, String label, dynamic value})
      : super(label: label, value: value);
  final T object;
  Iterable<Item> items;

  TextFormField get textFormField => TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      onSaved: (v) => onSaved(v));

  Text get textField => Text(value ?? "");

  CircleAvatar get circleAvatar => CircleAvatar(child: textField);

  ListTile get listTile => ListTile(title: Text(label), trailing: textField);

  ListItems get listItems => ListItems(title: label, items: (value ?? [this]));

  void onSaved(v); // => value = v;
}

/// Item class used for contact fields which only have a [label] and
/// a [value], such as emails and phone numbers
class Item {
  Item({this.label, this.value});
  String label;
  dynamic value;

  Item.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

  Map get toMap => {"label": label, "value": value};
}


class ListItems extends StatelessWidget {
  ListItems({this.title, this.items});
  final String title;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(title: Text(title)),
          Column(
              children: items
                  .map((i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                      title: Text(i.label ?? ""),
                      trailing: Text(i.value ?? ""))))
                  .toList())
        ]);
  }
}