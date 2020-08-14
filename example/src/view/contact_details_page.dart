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
        AppBar,
        BuildContext,
        Colors,
        CustomScrollView,
        FlatButton,
        Icon,
        Icons,
        Key,
        MaterialPageRoute,
        Navigator,
        Scaffold,
        SliverChildListDelegate,
        SliverList,
        StatelessWidget,
        Theme,
        Widget;
import 'package:mvc_application/view.dart'
    show
        App,
        EditBarButton,
        HomeBarButton,
        SearchBarButton,
        SimpleBottomAppBar,
        showBox;

import '../../controller.dart' show Controller;
import '../../model.dart' show Contact;
import '../../view.dart' show AddContactPage;

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactDetailsPage extends StatelessWidget {
  ContactDetailsPage({this.contact, Key key}) : super(key: key) {
    Controller.edit.init(contact);
  }
  final Object contact;

//  final double _appBarHeight = 256.0;
//
//  final AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: App.themeData,
        child: Scaffold(
            appBar: AppBar(title: Controller.edit.displayName.text, actions: [
              FlatButton(
                onPressed: () {
                  showBox(text: 'Delete this contact?', context: context)
                      .then((bool delete) {
                    if (delete) {
                      Controller.delete(contact).then((bool delete) {
                        if (delete) {
                          Controller.list.refresh();
                        }
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ]),
            bottomNavigationBar: SimpleBottomAppBar(
              button01: HomeBarButton(onPressed: () {
                Navigator.of(context).pop();
              }),
              button02: SearchBarButton(),
              button03: EditBarButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      AddContactPage(contact: contact, title: 'Edit a contact'),
                ));
              }),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Controller.edit.givenName.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.middleName.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.familyName.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.prefix.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.suffix.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.company.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.jobTitle.onListTile(tap: () {
                    editContact(contact, context);
                  }),
                  Controller.edit.phone.listItems,
                  Controller.edit.email.listItems,
                ]),
              )
            ])));
  }

  void editContact(Contact contact, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            AddContactPage(contact: contact, title: 'Edit a contact')));
  }
}
