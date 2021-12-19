import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/home/controller/contacts_controller.dart'
    show ContactsController;

import 'package:mvc_application_example/src/home/view/contacts/add_contact.dart';

import 'package:mvc_application_example/src/home/view/contacts/contact_details.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key, this.title = 'Contacts App'}) : super(key: key);
  final String title;
  @override
  State createState() => _ContactListState();
}

class _ContactListState extends StateMVC<ContactsList> {
  _ContactListState() : super(ContactsController()) {
    con = controller as ContactsController;
  }
  late ContactsController con;

  @override
  void initState() {
    super.initState();
    _title = App.title!;
    appCon = TemplateController();
  }

  String? _title;
  late TemplateController appCon;

  @override
  Widget build(BuildContext context) =>
      App.useMaterial ? _buildAndroid(this) : _buildiOS(this);
}

Widget _buildAndroid(_ContactListState state) {
  //
  final con = state.con;
  final appCon = state.appCon;
  return Scaffold(
    appBar: AppBar(
      title: Text(state._title ?? state.widget.title),
      actions: [
        TextButton(
          onPressed: () {
            con.sort();
          },
          child: const Icon(Icons.sort_by_alpha, color: Colors.white),
        ),
        appCon.popupMenu(),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        await Navigator.of(con.state!.context).push(MaterialPageRoute<void>(
          builder: (_) => const AddContact(),
        ));
        //     .then((_) {
        //   con.refresh();
        // });
        /// Either use the 'then' clause or the 'async await' command.
        con.refresh();
      },
      child: const Icon(Icons.add),
    ),
    body: SafeArea(
      child: con.items == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: con.items?.length ?? 0,
              itemBuilder: (_, int index) {
                final contact = con.itemAt(index);
                return contact!.displayName.onDismissible(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(),
                    ),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.of(con.state!.context)
                            .push(MaterialPageRoute<void>(
                          builder: (_) => ContactDetails(contact: contact),
                        ));
                        await con.getContacts();
                        con.state!.setState(() {});
                      },
                      leading: contact.displayName.circleAvatar,
                      title: contact.displayName.text,
                    ),
                  ),
                  dismissed: (DismissDirection direction) {
                    con.deleteItem(index);
                    final action = (direction == DismissDirection.endToStart)
                        ? 'deleted'
                        : 'archived';
                    App.snackBar(
                      duration: const Duration(milliseconds: 8000),
                      content: Text('You $action an item.'),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            contact.undelete();
                            state.refresh();
                          }),
                    );
                  },
                );
              },
            ),
    ),
  );
}

Widget _buildiOS(_ContactListState state) {
  //
  final con = state.con;
  final appCon = state.appCon;
  final widget = state.widget;
  final _theme = App.themeData;
  return CupertinoPageScaffold(
    child: CustomScrollView(
      semanticChildCount: 5,
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(state._title ?? widget.title),
          leading: Material(
            child: IconButton(
              icon: const Icon(Icons.sort_by_alpha),
              onPressed: () {
                con.sort();
              },
            ),
          ),
          middle: Material(
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(con.state!.context)
                    .push(MaterialPageRoute<void>(
                  builder: (_) => const AddContact(),
                ));
                con.refresh();
              },
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              appCon.popupMenu(),
            ],
          ),
        ),
        if (con.items == null)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                final contact = con.itemAt(index);
                return contact?.displayName.onDismissible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _theme?.canvasColor,
                      border: Border(
                        bottom: BorderSide(color: _theme!.dividerColor),
                      ),
                    ),
                    child: CupertinoListTile(
                      leading: contact.displayName.circleAvatar,
                      title: contact.displayName.text,
                      onTap: () async {
                        await Navigator.of(con.state!.context)
                            .push(MaterialPageRoute<void>(
                          builder: (_) => ContactDetails(contact: contact),
                        ));
                        await con.getContacts();
                        con.state!.setState(() {});
                      },
                    ),
                  ),
                  dismissed: (DismissDirection direction) {
                    con.deleteItem(index);
                    final action = (direction == DismissDirection.endToStart)
                        ? 'deleted'
                        : 'archived';
                    App.snackBar(
                      duration: const Duration(milliseconds: 8000),
                      content: Text('You $action an item.'),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            contact.undelete();
                            state.refresh();
                          }),
                    );
                  },
                );
              },
              childCount: con.items?.length,
              semanticIndexCallback: (Widget widget, int localIndex) {
                if (localIndex.isEven) {
                  return localIndex ~/ 2;
                }
                return null;
              },
            ),
          ),
      ],
    ),
  );
}
