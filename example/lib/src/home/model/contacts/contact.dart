import 'package:mvc_application_example/src/view.dart';

import 'contact_fields.dart';

import 'contacts_db.dart';

class Contact extends ContactEdit implements Comparable<Contact> {
  //
  Contact() {
    populate();
  }

  Contact.fromMap(Map<String, dynamic> map) {
    populate(map);
  }

  @override
  int compareTo(Contact other) =>
      _givenName.value.toString().compareTo(other._givenName.value.toString());
}

class ContactEdit extends ContactList {
  ContactEdit() {
    model = ContactsDB();
  }
  late ContactsDB model;

  GlobalKey<FormState> get formKey {
    if (!_inForm) {
      _inForm = true;
    }
    return _formKey;
  }

  bool _inForm = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> onPressed([BuildContext? context]) async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    _formKey.currentState!.save();
    _inForm = false;
    final added = await add();
    return added;
  }

  Future<bool> add() => model.addContact(this as Contact);

  Future<bool> delete() => model.deleteContact(this as Contact);

  Future<int> undelete() => model.undeleteContact(this as Contact);

  bool isChanged() => _givenName.changedFields
      .where((field) => field is! Phone && field is! Email)
      .isNotEmpty;

  bool phoneChange() => _givenName.changeIn<Phone>();

  bool emailChange() => _givenName.changeIn<Email>();
}

class ContactList extends ContactFields {
  //
  List<DataFieldItem>? _emails, _phones;

  void populate([Map<String, dynamic>? map]) {
    //
    final ma = MapClass(map);

    _id = Id(ma.p('id'));
    _givenName = GivenName(ma.p('givenName'));
    _middleName = MiddleName(ma.p('middleName'));
    _familyName = FamilyName(ma.p('familyName'));

    _displayName = displayName(this as Contact);
    _company = Company(ma.p('company'));
    _jobTitle = JobTitle(ma.p('jobTitle'));
    _phone = Phone(ma.p('phones'));
    _email = Email(ma.p('emails'));
  }

  Map<String, dynamic> get toMap {
    //
    final emailList = email.mapItems<Email>(
      'email',
      _emails,
      (data) => Email.init(data),
    );

    final phoneList = phone.mapItems<Phone>(
      'phone',
      _phones,
      (data) => Phone.init(data),
    );

    return {
      'id': _id.value,
      'displayName': _displayName.value,
      'givenName': _givenName.value,
      'middleName': _middleName.value,
      'familyName': _familyName.value,
      'emails': emailList,
      'phones': phoneList,
      'company': _company.value,
      'jobTitle': _jobTitle.value,
    };
  }
}

class ContactFields with StateGetter {
  //
  late FormFields _id,
      _displayName,
      _givenName,
      _middleName,
      _familyName,
      _phone,
      _email,
      _company,
      _jobTitle;

  /// Attach to a State object
  @override
  bool pushState([StateMVC? state]) {
    _id.pushState(state);
    _displayName.pushState(state);
    _givenName.pushState(state);
    _middleName.pushState(state);
    _familyName.pushState(state);
    _phone.pushState(state);
    _email.pushState(state);
    _company.pushState(state);
    _jobTitle.pushState(state);
    return super.pushState(state);
  }

  /// Detach from the State object
  @override
  bool popState() {
    _id.popState();
    _displayName.popState();
    _givenName.popState();
    _middleName.popState();
    _familyName.popState();
    _phone.popState();
    _email.popState();
    _company.popState();
    _jobTitle.popState();
    return super.popState();
  }

  Id get id => _id as Id;
  set id(Id id) => _id = id;

  DisplayName get displayName => _displayName as DisplayName;
  set displayName(DisplayName name) => _displayName = name;

  GivenName get givenName => _givenName as GivenName;
  set givenName(GivenName name) => _givenName = name;

  MiddleName get middleName => _middleName as MiddleName;
  set middleName(MiddleName name) => _middleName = name;

  FamilyName get familyName => _familyName as FamilyName;
  set familyName(FamilyName name) => _familyName = name;

  Company get company => _company as Company;
  set company(Company company) => _company = company;

  JobTitle get jobTitle => _jobTitle as JobTitle;
  set jobTitle(JobTitle job) => _jobTitle = job;

  Phone get phone => _phone as Phone;
  set phone(Phone phone) => _phone = phone;

  Email get email => _email as Email;
  set email(Email email) => _email = email;
}
