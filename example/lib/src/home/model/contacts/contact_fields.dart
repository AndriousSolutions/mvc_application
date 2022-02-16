import 'package:mvc_application_example/src/view.dart';

import 'contact.dart' show Contact;

/// Add to the class this:
/// `extends FieldWidgets<T> with FieldChange`
mixin FormFields on FieldWidgets<Contact> {
  //
  Set<FieldWidgets<Contact>> get changedFields => _changedFields;
  static final Set<FieldWidgets<Contact>> _changedFields = {};

  /// If the field's value changed, that field is added to a Set.
  @override
  void onSaved(dynamic v) {
    super.onSaved(v);
    if (isChanged()) {
      _changedFields.add(this);
    }
  }

  bool changeIn<T>() => changedFields.whereType<T>().isNotEmpty;
}

class Id extends FieldWidgets<Contact> with FormFields {
  Id(dynamic value) : super(label: 'Identifier', value: value);
}

String? notEmpty(String? v) =>
    v != null && v.isEmpty ? 'Cannot be empty' : null;

FormFields displayName(Contact contact) {
  String? display;

  if (contact.givenName.value != null) {
    display = contact.givenName.value ?? '';
    display = '$display ${contact.familyName.value}';
  }
  display ??= '';
  return DisplayName(display, Text(display));
}

class DisplayName extends FieldWidgets<Contact> with FormFields {
  DisplayName(String value, Widget child)
      : super(
          label: 'Display Name'.tr,
          value: value,
          child: child,
        );
}

class GivenName extends FieldWidgets<Contact> with FormFields {
  GivenName([dynamic value])
      : super(
          label: 'First Name'.tr,
          value: value,
          validator: notEmpty,
          keyboardType: TextInputType.name,
        );
}

class MiddleName extends FieldWidgets<Contact> with FormFields {
  MiddleName([dynamic value])
      : super(
          label: 'Middle Name'.tr,
          value: value,
          keyboardType: TextInputType.name,
        );
}

class FamilyName extends FieldWidgets<Contact> with FormFields {
  FamilyName([dynamic value])
      : super(
          label: 'Last Name'.tr,
          value: value,
          validator: notEmpty,
          keyboardType: TextInputType.name,
        );
}

class Company extends FieldWidgets<Contact> with FormFields {
  Company([dynamic value])
      : super(
          label: 'Company'.tr,
          value: value,
          keyboardType: TextInputType.name,
        );
}

class JobTitle extends FieldWidgets<Contact> with FormFields {
  JobTitle([dynamic value])
      : super(
          label: 'Job'.tr,
          value: value,
          keyboardType: TextInputType.name,
        );
}

class Phone extends FieldWidgets<Contact> with FormFields {
  //
  Phone([dynamic value])
      : super(
          label: 'Phone'.tr,
          value: value,
          inputDecoration: const InputDecoration(labelText: 'Phone'),
          keyboardType: TextInputType.phone,
        ) {
    // Change the name of the map's key fields.
    keys(value: 'phone');
    // There may be more than one phone number
    one2Many<Phone>(() => Phone());
  }

  Phone.init(DataFieldItem dataItem)
      : super(
          label: dataItem.label,
          value: dataItem.value,
          type: dataItem.type,
        );

  @override
  ListItems<Contact> onListItems({
    String? title,
    List<FieldWidgets<Contact>>? items,
    MapItemFunction? mapItem,
    GestureTapCallback? onTap,
    ValueChanged<String?>? onChanged,
    List<String>? dropItems,
  }) =>
      super.onListItems(
        title: title,
        items: items,
        mapItem: mapItem,
        onTap: onTap,
        onChanged: onChanged ?? (String? value) => state!.setState(() {}),
        dropItems: dropItems ??
            ['home'.tr, 'work'.tr, 'landline'.tr, 'mobile'.tr, 'other'.tr],
      );

  @override
  List<Map<String, dynamic>> mapItems<U extends FieldWidgets<Contact>>(
      String key,
      List<DataFieldItem>? items,
      U Function(DataFieldItem dataItem) create,
      [U? itemsObj]) {
    //
    final list = super.mapItems<U>(key, items, create, itemsObj);

    //ignore: unnecessary_cast
    for (int cnt = 0; cnt <= this.items!.length - 1; cnt++) {
      //
      final phone = this.items!.elementAt(cnt) as Phone;

      list[cnt]['initValue'] = phone.initialValue;
    }
    return list;
  }
}

class Email extends FieldWidgets<Contact> with FormFields {
  Email([dynamic value])
      : super(
          label: 'Email'.tr,
          value: value,
          inputDecoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ) {
    // There may be more than one email address.
    one2Many<Email>(() => Email());
  }

  Email.init(DataFieldItem dataItem)
      : super(
          label: dataItem.label,
          value: dataItem.value,
          type: dataItem.type,
        );

  @override
  ListItems<Contact> onListItems({
    String? title,
    List<FieldWidgets<Contact>>? items,
    MapItemFunction? mapItem,
    GestureTapCallback? onTap,
    ValueChanged<String?>? onChanged,
    List<String>? dropItems,
  }) =>
      super.onListItems(
        title: title,
        items: items,
        mapItem: mapItem,
        onTap: onTap,
        dropItems: dropItems ?? ['home'.tr, 'work'.tr, 'other'.tr],
        onChanged: onChanged ??
            (String? value) {
              state!.setState(() {});
            },
      );
}
