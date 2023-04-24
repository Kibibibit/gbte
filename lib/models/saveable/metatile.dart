import 'dart:math';

import 'package:gbte/globals/globals.dart';
import 'package:gbte/helpers/extensions/base64_string.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/saveable.dart';
import 'package:gbte/models/saveable/tile.dart';

class Metatile extends Saveable {
  int size;
  List<int> tiles;

  Metatile(this.size, this.tiles);

  Matrix2D createMatrix() {
    List<Matrix2D> rows = [];
    int i = 0;
    for (int y = 0; y < size; y++) {
      List<Matrix2D> columns = [];
      for (int x = 0; x < size; x++) {
        columns.add(Globals.tiles[tiles[i]].matrix);
        i++;
      }
      Matrix2D row = columns.removeAt(0);
      while (columns.isNotEmpty) {
        row = row.joinMatrix(MatrixAlignment.right, columns.removeAt(0));
      }
      rows.add(row);
    }
    Matrix2D metatileData = rows.removeAt(0);
    while (rows.isNotEmpty) {
      metatileData =
          metatileData.joinMatrix(MatrixAlignment.bottom, rows.removeAt(0));
    }
    return metatileData;
  }

  void fromMatrix(Matrix2D matrix) {
    assert(matrix.height == matrix.width, "Matrix must be square");
    assert(sqrt(matrix.height).roundToDouble() == sqrt(matrix.height), "Matrix size must have an Integer square root");
    assert((matrix.height/Tile.size).round() == size, "Matrix size must match metatile size (${matrix.height/Tile.size} != $size");

    for (int y = 0; y < matrix.height; y++) {
      for (int x = 0; x < matrix.width; x++) {

        int tx = (x / Tile.size).floor();
        int ty = (y / Tile.size).floor();
        int ti = (size*ty)+tx;

        Globals.tiles[tiles[ti]].set(x % Tile.size, y % Tile.size, matrix.get(x,y));

      }
    }

  }

  List<String> toBytes() {
    return tiles.map((e) => Globals.tiles[e].save()).toList();
  }

  @override
  void load(String data) {
    List<String> decoded = data.split(",");
    String header = decoded.removeAt(0);

    assert(header == Saveable.metatileHeader);

    size = decoded.removeAt(0).fromByteString();

    tiles = [];
    for (String t in decoded) {
      tiles.add(t.fromByteString());
    }

  }

  @override
  String save() {
    List<String> out = [Saveable.metatileHeader, size.toByteString(1)];
    for (int tile in tiles) {
      out.add(tile.toByteString(2));
    }
    return out.join(",").toBase64();
  }
}
