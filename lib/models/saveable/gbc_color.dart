import 'package:flutter/material.dart';
import 'package:gbte/helpers/map_range.dart';
import 'package:gbte/models/saveable/exportable.dart';

class GBCColor extends Exportable {
  static const int minC = 0;
  static const int maxC = 31;

  late int r;
  late int g;
  late int b;

  GBCColor({required this.r, required this.g, required this.b})
      : assert(_validColor(r) && _validColor(g) && _validColor(b),
            "Values must be between 0 and 31");

  static bool _validColor(int x) => x >= minC && x <= maxC;

  int _mapColor(int x) {
    return mapRange(x, minC, maxC, 0, 255);
  }

  Color toColor() {
    return Color.fromRGBO(_mapColor(r), _mapColor(g), _mapColor(b), 1.0);
  }
  
  @override
  void load(String data) {

    List<String> d = data.replaceAll("{", "").replaceAll("}", "").split(".");
    r = int.parse(d[0]);
    g = int.parse(d[1]);
    b = int.parse(d[2]);
  }
  
  @override
  String save() => "{$r.$g.$b}";
  
  @override
  List<int> export() {
    int out = b & 31;
    out <<= 5;
    out += g & 31;
    out <<= 5;
    out += r & 31;

    return [out];
  }
  
}
