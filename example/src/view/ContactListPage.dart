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
        ThemeData,
        Widget;

import 'package:mvc_application/view.dart' show App, AppMenu, StateMVC;

import '../../view.dart' show AppMenu, ContactDetailsPage, StateMVC;

import '../../controller.dart' show Controller;

class ContactListPage extends StatefulWidget {
  ContactListPage({Key key}) : super(key: key);

  State createState() => _ContactListState();
}

class _ContactListState extends StateMVC<ContactListPage> {
  _ContactListState() : super(Controller()) {
    con = controller;
  }
  Controller con;

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = App.themeData;
    return Theme(
      data: App.themeData,
      child: Scaffold(
        key: Controller.list.scaffoldKey,
        appBar: AppBar(title: Text('Contacts Example'), actions: <Widget>[
          FlatButton(
              child: Icon(Icons.sort_by_alpha, color: Colors.white),
              onPressed: () {
                Controller.list.sort();
              }),
          AppMenu().show(this),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("/add").then((_) {
                Controller.list.refresh();
              });
            }),
        body: SafeArea(
          child: Controller.list.items == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: Controller.list.items?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Object c = con.child(index);
                    return Controller.list.displayName.onDismissible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: _theme.canvasColor,
                            border: Border(
                                bottom:
                                    BorderSide(color: _theme.dividerColor))),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ContactDetailsPage(contact: c)));
                          },
                          leading: Controller.list.displayName.circleAvatar,
                          title: Controller.list.displayName.text,
                        ),
                      ),
                      dismissed: (DismissDirection direction) {
                        Controller.delete(c).then((_) {
                          Controller.list.refresh();
                        });
                        final String action =
                            (direction == DismissDirection.endToStart)
                                ? 'deleted'
                                : 'archived';
                        Controller.list.scaffoldKey.currentState
                            ?.showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 8000),
                                content: Text('You $action an item.'),
                                action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      Controller.edit.undelete(c);
                                      Controller.list.refresh();
                                    })));
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
