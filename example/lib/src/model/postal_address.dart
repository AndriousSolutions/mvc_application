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

class PostalAddress {
  PostalAddress({
    this.label,
  }) {
    label ??= '';
  }

  PostalAddress.fromMap(Map<String, String> m) {
    label = m['label'];
    _street = m['street'];
    _city = m['city'];
    _postcode = m['postcode'];
    _region = m['region'];
    _country = m['country'];
  }

  String label, _street, _city, _postcode, _region, _country;

  String get street => _street;
  set street(String street) {
    street ??= '';
    _street = street;
  }

  String get city => _city;
  set city(String city) {
    city ??= '';
    _city = city;
  }

  String get postcode => _postcode;
  set postcode(String code) {
    code ??= '';
    _postcode = code;
  }

  String get region => _region;
  set region(String region) {
    region ??= '';
    _region = region;
  }

  String get country => _country;
  set country(String country) {
    country ??= '';
    _country = country;
  }

  Map<String, String> get toMap => {
        'label': label,
        'street': _street,
        'city': _city,
        'postcode': _postcode,
        'region': _region,
        'country': _country
      };
}
