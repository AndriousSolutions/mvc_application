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
        State,
        StatefulWidget,
        Theme,
        VoidCallback,
        Widget;

import 'package:mvc_application/view.dart'
    show App, EditBarButton, HomeBarButton, SimpleBottomAppBar, showBox;

import '../../model.dart' show Contact;

import '../../view.dart' show AddContact;

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactDetails extends StatefulWidget {
  const ContactDetails({this.contact, Key key}) : super(key: key);
  final Contact contact;
  @override
  State createState() => _DetailsState();
}

class _DetailsState extends State<ContactDetails> {
  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  VoidCallback onTap;
  Contact contact;

  @override
  Widget build(BuildContext context) {
    onTap = () {
      editContact(contact, context);
    };
    return Theme(
        data: App.themeData,
        child: Scaffold(
            appBar: AppBar(title: contact.displayName.text, actions: [
              FlatButton(
                onPressed: () {
                  showBox(text: 'Delete this contact?', context: context)
                      .then((bool delete) {
                    if (delete) {
                      contact.delete().then((_) {
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
              button03: EditBarButton(onPressed: onTap),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  contact.givenName.onListTile(tap: onTap),
                  contact.middleName.onListTile(tap: onTap),
                  contact.familyName.onListTile(tap: onTap),
                  contact.phone.onListItems(onTap: onTap),
                  contact.email.onListItems(onTap: onTap),
                  contact.company.onListTile(tap: onTap),
                  contact.jobTitle.onListTile(tap: onTap),
                ]),
              )
            ])));
  }

  Future<void> editContact(Contact contact, BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            AddContact(contact: contact, title: 'Edit a contact')));
    setState(() {});
  }
}
