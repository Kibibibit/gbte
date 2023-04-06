import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gbte/helpers/map_range.dart';
import 'package:gbte/models/saveable.dart';

class GBCColor extends Saveable {
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
  void load(Uint8List data) {

    int byteString = 0;

    for (int i = 0; i < data.length; i++) {
      byteString = (byteString << 8) + data[i];
    }
    r = (byteString >> 10) & 31;
    g = (byteString >> 5) & 31;
    b = (byteString) & 31;

  }
  
  @override
  Uint8List save() {
    int data = (r << 10) + (g << 5) + b;

    List<int> out = [];
    
    for (int i = 0; i < 2; i++) {
      int mask = (255 << 8*(1-i));
      int masked = data&mask;
      int shift = masked >> 8*(1-i);
      out.add(shift);
    }

    return Uint8List.fromList(out);
  }
}
