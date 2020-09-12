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

import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        Key,
        ListTile,
        Padding,
        StatelessWidget,
        Text,
        Widget;

import '../../model.dart' show PostalAddress;

class AddressesTile extends StatelessWidget {
  const AddressesTile(this._addresses, {Key key}) : super(key: key);
  final List<PostalAddress> _addresses;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ListTile(title: Text('Addresses')),
          Column(
              children: _addresses
                  .map((a) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: const Text('Street'),
                                trailing: Text(a.street)),
                            ListTile(
                                title: const Text('Postcode'),
                                trailing: Text(a.postcode)),
                            ListTile(
                                title: const Text('City'), trailing: Text(a.city)),
                            ListTile(
                                title: const Text('Region'),
                                trailing: Text(a.region)),
                            ListTile(
                                title: const Text('Country'),
                                trailing: Text(a.country)),
                          ],
                        ),
                      ))
                  .toList())
        ]);
  }
}
