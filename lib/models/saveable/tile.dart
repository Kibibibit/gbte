
import 'dart:typed_data';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/saveable.dart';

class Tile extends Saveable {
  static const int size = 8;

  late Matrix2D _data;

  Tile() {
    _data = Matrix2D(size, size);
  }


  int get(int x, int y) {
    return _data.get(x,y);
  }


  void set(int x, int y, int value) {
    assert(value >= 0 && value < 4, "Pixel must be 0-3");
    _data.set(x,y,value);
  }

  Matrix2D get matrix => _data.copy();

  @override
  void load(Uint8List data) {
    List<int> bytes = data.toList();
    int header = bytes.removeAt(0);

    assert(header == Saveable.tileHeader, "Tried to load a tile with a non-tile value");

    for (int i = 0; i < bytes.length; i++) {
      int byte = bytes[i];
      for (int j = 0; j < 4; j++) {
        _data.setI((i*4)+j,(byte >> (6-(j*2))) & 3);
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
        p = (p << 2) + _data.getI((i * 4) + j);
      }
      out.add(p);
    }
    return Uint8List.fromList(out);
  }

  static Tile fromMatrix(Matrix2D matrix) {
    assert(matrix.height == Tile.size && matrix.width == Tile.size,"Tile matrix must be 8*8"); 
    Tile out = Tile();
    for (int i = 0; i < Tile.size*Tile.size; i++) {
      out._data.setI(i, matrix.getI(i));
    }
    return out;
  }

  @override
  Uint8List export() {
    List<int> out = [];

    for (int y = 0; y < Tile.size; y++) {
      int a = 0;
      int b = 0;

      for (int x = 0; x < Tile.size; x++) {
        int val = get(x, y);
        int aVal = val & 0x01;
        int bVal = (val & 0x02) >> 1;
        a <<= 1;
        a += aVal;
        b <<= 1;
        b += bVal;
        
        
      }

      out.add(a);
      out.add(b);

    }
    return Uint8List.fromList(out);

  }

}
