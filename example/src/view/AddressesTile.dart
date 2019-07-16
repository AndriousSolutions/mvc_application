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
  AddressesTile(this._addresses, {Key key}) : super(key: key);
  final List<PostalAddress> _addresses;

  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(title: Text("Addresses")),
          Column(
              children: _addresses
                  .map((a) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: Text("Street"),
                                trailing: Text(a.street)),
                            ListTile(
                                title: Text("Postcode"),
                                trailing: Text(a.postcode)),
                            ListTile(
                                title: Text("City"), trailing: Text(a.city)),
                            ListTile(
                                title: Text("Region"),
                                trailing: Text(a.region)),
                            ListTile(
                                title: Text("Country"),
                                trailing: Text(a.country)),
                          ],
                        ),
                      ))
                  .toList())
        ]);
  }
}
