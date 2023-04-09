
import 'dart:typed_data';
import 'package:gbte/models/saveable.dart';

class Tile extends Saveable {
  static const int size = 8;

  late List<int> _data;

  Tile() {
    _data = List.generate(size * size, (_) => 0);
  }

  int _index(int x, int y) {
    assert(x >= 0 && x < size && y >= 0 && y < size, "Invalid tile index!");
    return (y * size) + x;
  }

  int get(int x, int y) {
    return _data[_index(x, y)];
  }


  void set(int x, int y, int value) {
    assert(value >= 0 && value < 4, "Pixel must be 0-3");
    _data[_index(x, y)] = value;
  }

  Tile clone() {
    Tile out = Tile();
    for (int i = 0; i < _data.length; i++) {
      out._data[i] = _data[i];
    }
    return out;
  }

  @override
  void load(Uint8List data) {
    List<int> bytes = data.toList();
    int header = bytes.removeAt(0);

    assert(header == Saveable.tileHeader, "Tried to load a tile with a non-tile value");

    for (int i = 0; i < bytes.length; i++) {
      int byte = bytes[i];
      for (int j = 0; j < 4; j++) {
        _data[(i*4)+j] = (byte >> (6-(j*2))) & 3;
      }

    }

  }

  @override
  Uint8List save() {
    List<int> out = [];
    out.add(Saveable.tileHeader);

    for (int i = 0; i < 16; i++) {
      int p = 0;
      for (int j = 0; j < 4; j++) {
        p = (p << 2) + _data[(i * 4) + j];
      }
      out.add(p);
    }
    return Uint8List.fromList(out);
  }
  
  @override
  Tile copy() {
    Tile out = Tile();
    for (int i = 0; i < _data.length; i ++) {
      out._data[i] = _data[i];
    }
    return out;
  }
}
