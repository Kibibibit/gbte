import 'dart:math';
import 'dart:typed_data';

import 'package:gbte/globals/globals.dart';
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

  List<Uint8List> toBytes() {
    return tiles.map((e) => Globals.tiles[e].save()).toList();
  }

  @override
  void load(Uint8List data) {
    List<int> bytes = data.toList();
    tiles = [];
    size = bytes.removeAt(0);
    int elements = size * size;
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
