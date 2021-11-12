import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application_example/src/home/model/contacts/contact.dart'
    show Contact;

import 'add_contact.dart' show AddContact;

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactDetails extends StatefulWidget {
  const ContactDetails({required this.contact, Key? key}) : super(key: key);
  final Contact contact;
  @override
  State createState() => _DetailsState();
}

class _DetailsState extends StateMVC<ContactDetails> {
  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  late Contact contact;

  @override
  Widget build(BuildContext context) =>
      App.useMaterial ? _BuildAndroid(state: this) : _BuildiOS(state: this);

  // Provide a means to 'edit' the details
  Future<void> editContact(Contact? contact, BuildContext context) async {
    //
    final widget = AddContact(contact: contact, title: 'Edit a contact');

    PageRoute<void> route;

    if (App.useMaterial) {
      route =
          MaterialPageRoute<void>(builder: (BuildContext context) => widget);
    } else {
      route =
          CupertinoPageRoute<void>(builder: (BuildContext context) => widget);
    }
    await Navigator.of(context).push(route);
    final contacts = await contact!.model.getContacts();
    this.contact = contacts
        .firstWhere((contact) => contact.id.value == this.contact.id.value);
    setState(() {});
  }
}

// Android interface
class _BuildAndroid extends StatelessWidget {
  const _BuildAndroid({Key? key, required this.state}) : super(key: key);
  final _DetailsState state;

  @override
  Widget build(BuildContext context) {
    final contact = state.contact;
    // Dart allows for local function declarations
    onTap() => state.editContact(contact, context);
    return Scaffold(
      appBar: AppBar(title: contact.displayName.text, actions: [
        TextButton(
          onPressed: () async {
            // Confirm the deletion
            final delete =
                await showBox(text: 'Delete this contact?', context: context);

            if (delete) {
              //
              await contact.delete();

              Navigator.of(context).pop();
            }
            // // A 'then' clause implementation.
            // showBox(text: 'Delete this contact?', context: context)
            //     .then((bool delete) {
            //   if (delete) {
            //     contact.delete().then((_) {
            //       Navigator.of(context).pop();
            //     });
            //   }
            // });
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
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            contact.givenName.onListTile(tap: onTap),
            contact.middleName.onListTile(tap: onTap),
            contact.familyName.onListTile(tap: onTap),
            contact.phone.onListItems(onTap: onTap),
            contact.email.onListItems(onTap: onTap),
            contact.company.onListTile(tap: onTap),
            contact.jobTitle.onListTile(tap: onTap),
          ]),
        )
      ]),
    );
  }
}

// iOS interface
class _BuildiOS extends StatelessWidget {
  const _BuildiOS({Key? key, required this.state}) : super(key: key);
  final _DetailsState state;

  @override
  Widget build(BuildContext context) {
    final contact = state.contact;
    // Dart allows for local function declarations
    onTap() => state.editContact(contact, context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Home',
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        middle: const Text('Sample'),
        trailing: Material(
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showBox(text: 'Delete this contact?', context: context)
                  .then((bool delete) {
                if (delete) {
                  contact.delete().then((_) {
                    Navigator.of(context).maybePop();
                  });
                }
              });
            },
          ),
        ),
      ),
      child: CustomScrollView(slivers: <Widget>[
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
        ),
      ]),
    );
  }
}
