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
        Container,
        EdgeInsets,
        FlatButton,
        Form,
        Icon,
        Icons,
        Key,
        ListView,
        Navigator,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;

import '../../model.dart' show Contact, PostalAddress;

import '../../view.dart' show StateMVC;

import '../../controller.dart' show Controller;

class AddContactPage extends StatefulWidget {
  AddContactPage({this.contact, this.title, Key key}) : super(key: key);
  final Object contact;
  final String title;

  @override
  State createState() => _AddContactState();
}

class _AddContactState extends StateMVC<AddContactPage> {
  final PostalAddress address = PostalAddress(label: "Home");

  @override
  void initState() {
    super.initState();
    Controller.add.init(widget.contact);
    //   _address = PostalAddress(label: "Home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Add a contact"),
        actions: [
          FlatButton(
            child: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Controller.add.onPressed();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
            key: Controller.add.formKey,
            child: ListView(
              children: [
                Controller.add.givenName.textFormField,
                Controller.add.middleName.textFormField,
                Controller.add.familyName.textFormField,
                Controller.add.prefix.textFormField,
                Controller.add.suffix.textFormField,
                Controller.add.phone.textFormField,
                Controller.add.email.textFormField,
                Controller.add.company.textFormField,
                Controller.add.jobTitle.textFormField,
                Controller.add.street.textFormField,
                Controller.add.city.textFormField,
                Controller.add.region.textFormField,
                Controller.add.postcode.textFormField,
                Controller.add.country.textFormField,
              ],
            )),
      ),
    );
  }
}
