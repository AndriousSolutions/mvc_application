import 'package:mvc_application_example/src/view.dart';

import 'package:mvc_application_example/src/controller.dart';

import 'package:mvc_application_example/src/home/model/contacts/contact.dart';

import 'package:mvc_application_example/src/home/model/contacts/contacts_db.dart';

class ContactsController extends AppController {
  //
  factory ContactsController([StateMVC? state]) =>
      _this ??= ContactsController._(state);

  ContactsController._([StateMVC? state])
      : model = ContactsDB(),
        super(state);
  final ContactsDB model;
  static ContactsController? _this;

  @override
  Future<bool> initAsync() async {
    _sortedAlpha = Prefs.getBool(sortKEY, false);
    final init = await model.initState();
    if (init) {
      await getContacts();
    }
    return init;
  }

  static late bool _sortedAlpha;
  static const String sortKEY = 'sort_by_alpha';

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    /// Supply an 'error handler' routine if something goes wrong
    /// in the corresponding initAsync() routine.
    /// Returns true if the error was properly handled.
    return false;
  }

  // Merely for demonstration purposes. Erase if not using.
  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  Future<List<Contact>> getContacts() async {
    _contacts = await model.getContacts();
    if (_sortedAlpha) {
      _contacts!.sort();
    }
    return _contacts!;
  }

  @override
  Future<void> refresh() async {
    await getContacts();
    super.refresh();
  }

  /// Called by menu option
  Future<List<Contact>> sort() async {
    _sortedAlpha = !_sortedAlpha;
    await Prefs.setBool(sortKEY, _sortedAlpha);
    await refresh();
    return _contacts!;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Contact>? get items => _contacts;
  List<Contact>? _contacts;

  Contact? itemAt(int index) => items?.elementAt(index);

  Future<bool> deleteItem(int index) async {
    final Contact? contact = items?.elementAt(index);
    var delete = contact != null;
    if (delete) {
      delete = await contact.delete();
    }
    await refresh();
    return delete;
  }
}
