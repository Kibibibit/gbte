import 'dart:convert';

extension Base64String on String {

  String toBase64() => base64Encode(utf8.encode(this));
  String fromBase64() => utf8.decode(base64Decode(this));

}