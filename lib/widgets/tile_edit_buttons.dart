import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';

class TileEditButtons extends StatelessWidget {

  final List<int> tiles;
  final int metatileSize;
  const TileEditButtons({super.key, required this.tiles, required this.metatileSize});

  

  void shunt(ShuntDirection direction) {
    List<Matrix2D> rows = [];
    int i = 0;
    for (int y = 0; y < metatileSize; y++) {
      List<Matrix2D> columns = [];
      for (int x = 0; x < metatileSize; x++) {
        columns.add(Globals.tiles[i].matrix);
      }
      Matrix2D row = columns.removeAt(0);
      while (columns.isNotEmpty) {
        row = row.joinMatrix(MatrixAlignment.right, columns.removeAt(0));
      }
      rows.add(row);
    }
    Matrix2D metatileData = rows.removeAt(0);
    while (rows.isNotEmpty) {
      metatileData = metatileData.joinMatrix(MatrixAlignment.bottom, rows.removeAt(0));
    }

    metatileData = metatileData.shunt(direction);

    //TODO: Submatrix then rebuild tiles

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(onPressed: () => shunt(ShuntDirection.up), icon: const Icon(Icons.north)),
          IconButton(onPressed: () => shunt(ShuntDirection.down), icon: const Icon(Icons.south)),
          IconButton(onPressed: () => shunt(ShuntDirection.left), icon: const Icon(Icons.west)),
          IconButton(onPressed: () => shunt(ShuntDirection.right), icon: const Icon(Icons.east)),
        ],
      ),
    );
  }

}

