import 'dart:typed_data';

abstract class Saveable {

  static const int paletteHeader = 1;
  static const int tileHeader = 2;

  Uint8List save();
  void load(Uint8List data);

}