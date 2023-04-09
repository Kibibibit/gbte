import 'dart:typed_data';

abstract class Saveable {

  static const int paletteHeader = 0;
  static const int tileHeader = 1;

  static const int paletteByteLength = 9;
  static const int tileByteLength = 17;

  static const List<int> dataHeaders = [paletteHeader, tileHeader];
  static const List<int> dataSizes = [paletteByteLength, tileByteLength];

  Uint8List save();
  void load(Uint8List data);

  Saveable copy();

}