import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/tile_app_event.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/tile.dart';

class TileEditButtons extends StatelessWidget {

  final List<int> tiles;
  final int metatileSize;
  const TileEditButtons({super.key, required this.tiles, required this.metatileSize});

  List<Uint8List> _mapTiles(List<int> tiles) => tiles.map((tile) => Globals.tiles[tile].save()).toList();
  

  void shunt(ShuntDirection direction) {
    List<Uint8List> previousTiles = _mapTiles(tiles);
    List<Matrix2D> rows = [];
    int i = 0;
    for (int y = 0; y < metatileSize; y++) {
      List<Matrix2D> columns = [];
      for (int x = 0; x < metatileSize; x++) {
        columns.add(Globals.tiles[tiles[i]].matrix);
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
    i = 0;
    for (int x = 0; x < metatileSize; x++) {
      for (int y = 0; y < metatileSize; y++) {

        int tx = x*Tile.size;
        int ty = y*Tile.size;
        Matrix2D tileMatrix = metatileData.subMatrix(tx, ty, Tile.size, Tile.size);
        Globals.tiles[tiles[i]] = Tile.fromMatrix(tileMatrix);
        
        Events.updateTile(tiles[i]);
        i++;
      }
    }

    Events.appEvent(TileAppEvent(tileIndices: tiles, previousTiles: previousTiles, nextTiles: _mapTiles(tiles)));

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

