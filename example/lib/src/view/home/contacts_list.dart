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
        Border,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Colors,
        Container,
        DismissDirection,
        FlatButton,
        FloatingActionButton,
        Icon,
        Icons,
        InheritedTheme,
        Key,
        ListTile,
        ListView,
        MaterialPageRoute,
        Navigator,
        SafeArea,
        Scaffold,
        SnackBar,
        SnackBarAction,
        State,
        StatefulWidget,
        Text,
        Theme,
        Widget;

import 'package:mvc_application/view.dart' show App, AppMenu, StateMVC;

import '../../controller.dart' show Controller;

import '../../model.dart' show Contact;

import '../../view.dart' show AppMenu, ContactDetails, StateMVC;

class ContactsList extends StatefulWidget {
  const ContactsList({Key key}) : super(key: key);
  @override
  State createState() => _ContactListState();
}

class _ContactListState extends StateMVC<ContactsList> {
  _ContactListState() : super(Controller()) {
    con = controller;
  }
  Controller con;

  @override
  Widget build(BuildContext context) {
    final _theme = App.themeData;
    return Theme(
      data: _theme,
      child: Scaffold(
        key: con.scaffoldKey,
        appBar: AppBar(
          title: Text(App.vw.title),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                con.sort();
              },
              child: const Icon(Icons.sort_by_alpha, color: Colors.white),
            ),
            AppMenu().show(this),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _theme.primaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/add').then((_) {
              con.refresh();
            });
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: con.items == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: con.items?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final Contact contact = con.itemAt(index);
                    return contact.displayName.onDismissible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: _theme.canvasColor,
                            border: Border(
                                bottom:
                                    BorderSide(color: _theme.dividerColor))),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute<void>(
                              builder: (BuildContext _) =>
                                  InheritedTheme.captureAll(
                                      context, ContactDetails(contact: contact)),
                            ))
                                .then((_) {
                              con.refresh();
                            });
                          },
                          leading: contact.displayName.circleAvatar,
                          title: contact.displayName.text,
                        ),
                      ),
                      dismissed: (DismissDirection direction) {
                        con.deleteItem(index);
                        final String action =
                            (direction == DismissDirection.endToStart)
                                ? 'deleted'
                                : 'archived';
                        con.scaffoldKey.currentState?.showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 8000),
                            content: Text('You $action an item.'),
                            action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  contact.undelete();
                                  // ignore: cascade_invocations
                                  con.refresh();
                                }),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
