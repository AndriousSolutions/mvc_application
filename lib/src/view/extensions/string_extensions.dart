/// MIT License
///
/// Copyright (c) 2019 Jonny Borges
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Original source: get 4.6.1

import 'package:mvc_application/src/controller/get_utils/get_utils.dart';

///
extension GetStringUtils on String {
  /// Is this String a number?
  bool get isNum => GetUtils.isNum(this);

  /// Is this String all numeric characters?
  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  /// Is this String all alphabetical characters?
  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  /// Is this String a boolean value?
  bool get isBool => GetUtils.isBool(this);

  /// Is this String a Vector?
  bool get isVectorFileName => GetUtils.isVector(this);

  /// Is this String an Image file?
  bool get isImageFileName => GetUtils.isImage(this);

  /// Is this String an Audio file?
  bool get isAudioFileName => GetUtils.isAudio(this);

  /// Is this String a Video file?
  bool get isVideoFileName => GetUtils.isVideo(this);

  /// Is this String a txt file?
  bool get isTxtFileName => GetUtils.isTxt(this);

  /// Is this String a Word file?
  bool get isDocumentFileName => GetUtils.isWord(this);

  /// Is this String an Excel file?
  bool get isExcelFileName => GetUtils.isExcel(this);

  /// Is this String an PPT file?
  bool get isPPTFileName => GetUtils.isPPT(this);

  /// Is this String is an APK file?
  bool get isAPKFileName => GetUtils.isAPK(this);

  /// Is this String is an PDF file?
  bool get isPDFFileName => GetUtils.isPDF(this);

  /// Is this String an HTML file?
  bool get isHTMLFileName => GetUtils.isHTML(this);

  /// Is this String a URL?
  bool get isURL => GetUtils.isURL(this);

  /// Is this String an Email?
  bool get isEmail => GetUtils.isEmail(this);

  /// Is this String a phone number?
  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  /// Is this String a DateTime value?
  bool get isDateTime => GetUtils.isDateTime(this);

  /// Is this String
  bool get isMD5 => GetUtils.isMD5(this);

  /// Is this String a SHA1 character string?
  bool get isSHA1 => GetUtils.isSHA1(this);

  /// Is this String a SHA256 character string?
  bool get isSHA256 => GetUtils.isSHA256(this);

  /// Is this String a Binary character string?
  bool get isBinary => GetUtils.isBinary(this);

  /// Is this String a IPv4 character string?
  bool get isIPv4 => GetUtils.isIPv4(this);

  /// Is this String a IPv6 character string?
  bool get isIPv6 => GetUtils.isIPv6(this);

  /// Is this String an Hexadecimal character string?
  bool get isHexadecimal => GetUtils.isHexadecimal(this);

  /// Is this String a Palindrom?
  bool get isPalindrom => GetUtils.isPalindrom(this);

  /// This string is a Passport value?
  bool get isPassport => GetUtils.isPassport(this);

  /// Is this String a currency?
  bool get isCurrency => GetUtils.isCurrency(this);

  /// Is this String is a Cpf character string?
  bool get isCpf => GetUtils.isCpf(this);

  /// Is this String is Cnpj character string?
  bool get isCnpj => GetUtils.isCnpj(this);

  /// Does the provided string contained in this string?
  bool isCaseInsensitiveContains(String b) =>
      GetUtils.isCaseInsensitiveContains(this, b);

  /// Does any of the string value contained in this string?
  bool isCaseInsensitiveContainsAny(String b) =>
      GetUtils.isCaseInsensitiveContainsAny(this, b);

  /// Return this String all capitalized.
  String? get capitalize => GetUtils.capitalize(this);

  /// Return this String starting with a capital letter.
  String? get capitalizeFirst => GetUtils.capitalizeFirst(this);

  /// Return this String with no blanks.
  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  /// Return this String in camelcase format.
  String? get camelCase => GetUtils.camelCase(this);

  /// Return this String to param case format.
  String? get paramCase => GetUtils.paramCase(this);

  /// Return this String with only numbers.
  String numericOnly({bool firstWordOnly = false}) =>
      GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  /// Return this String as a path with optional segments inserted.
  String createPath([Iterable<dynamic>? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return GetUtils.createPath(path, segments);
  }
}
