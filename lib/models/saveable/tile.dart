import 'package:gbte/helpers/extensions/base64_string.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/exportable.dart';
import 'package:gbte/models/saveable/saveable.dart';

class Tile extends Exportable {
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
  void load(String data) {

    List<String> dataList = data.split(",");
    String header = dataList.removeAt(0);

    assert(header == Saveable.tileHeader, "Tried to load a tile with a non-tile value");

    for (int i = 0; i < dataList.length; i++) {
      int byte = dataList[i].fromByteString();
      _data.setI(i, byte);
    }
  }

  @override
  String save() {
    List<String> out = [];
    out.add(Saveable.tileHeader);
    for (int i = 0; i < Tile.size*Tile.size; i++){
      out.add(_data.getI(i).toByteString(1));
    } 
    return out.join(",").toBase64();
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
  List<int> export() {
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

      out.add(a & 0xFF);
      out.add(b & 0xFF);

    }
    return out;

  }

}
