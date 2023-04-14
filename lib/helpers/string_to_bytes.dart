
import 'dart:convert';

import 'package:gbte/helpers/int_to_bytes.dart';

List<int> stringToBytes(String string) {
  List<int> bytes = utf8.encode(string);
  List<int> out = intToBytes(bytes.length);

  out.addAll(bytes);

  return out;

}