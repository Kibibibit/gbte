import 'dart:typed_data';

import 'package:gbte/models/saveable/saveable.dart';

class Metatile extends Saveable {

  int size;
  List<int> tiles;

  Metatile(this.size, this.tiles);

  @override
  void load(Uint8List data) {
    List<int> bytes = data.toList();
    tiles = [];
    size = bytes.removeAt(0);
    int elements = size*size;
    for (int i = 0; i < elements; i++) {
      int upper = bytes.removeAt(0);
      int lower = bytes.removeAt(0);
      int tile = (upper << 8) + lower;
      tiles.add(tile);
    }
  }

  @override
  Uint8List save() {
    List<int> out = [size];
    for (int tile in tiles) {
      int upper = (tile & 0xF0) >> 8;
      int lower = tile & 0x0F;
      out.add(upper);
      out.add(lower);
    }
    return Uint8List.fromList(out);
  }
  
}