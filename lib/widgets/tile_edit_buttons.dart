import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/tile_app_event.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/widgets/tooltip_icon_button.dart';

class TileEditButtons extends StatelessWidget {
  final List<int> tiles;
  final int metatileSize;
  const TileEditButtons(
      {super.key, required this.tiles, required this.metatileSize});

  List<String> _mapTiles(List<int> tiles) =>
      tiles.map((tile) => Globals.tiles[tile].save()).toList();

  Matrix2D createMetatileMatrix() {
    Metatile metatile = Metatile(metatileSize, tiles);
    return metatile.createMatrix();
  }

  void breakdownMetatile(Matrix2D metatileData, List<String> previousTiles) {
    int i = 0;

    for (int y = 0; y < metatileSize; y++) {
      for (int x = 0; x < metatileSize; x++) {
        int tx = x * Tile.size;
        int ty = y * Tile.size;
        Matrix2D tileMatrix =
            metatileData.subMatrix(tx, ty, Tile.size, Tile.size);
        Globals.tiles[tiles[i]] = Tile.fromMatrix(tileMatrix);

        Events.updateTile(tiles[i]);
        i++;
      }
    }

    Events.appEvent(TileAppEvent(
        tileIndices: tiles,
        previousTiles: previousTiles,
        nextTiles: _mapTiles(tiles)));
  }

  void shunt(ShuntDirection direction) {
    List<String> previousTiles = _mapTiles(tiles);
    Matrix2D metatileData = createMetatileMatrix();
    metatileData = metatileData.shunt(direction);
    breakdownMetatile(metatileData, previousTiles);
  }

  void mirror(bool vertical) {
    List<String> previousTiles = _mapTiles(tiles);
    Matrix2D metatileData = createMetatileMatrix();
    metatileData = metatileData.mirror(vertical);
    breakdownMetatile(metatileData, previousTiles);
  }

  void rotate(bool counterClockWise) {
    List<String> previousTiles = _mapTiles(tiles);
    Matrix2D metatileData = createMetatileMatrix();
    metatileData = metatileData.rotate(counterClockWise);
    breakdownMetatile(metatileData, previousTiles);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TooltipIconButton(
              message: "Translate up",
              onPressed: () => shunt(ShuntDirection.up),
              icon: const Icon(Icons.north)),
          TooltipIconButton(
              message: "Translate down",
              onPressed: () => shunt(ShuntDirection.down),
              icon: const Icon(Icons.south)),
          TooltipIconButton(
              message: "Translate left",
              onPressed: () => shunt(ShuntDirection.left),
              icon: const Icon(Icons.west)),
          TooltipIconButton(
              message: "Translate right",
              onPressed: () => shunt(ShuntDirection.right),
              icon: const Icon(Icons.east)),
          const Divider(),
          TooltipIconButton(
              message: "Flip horizontally",
              onPressed: () => mirror(false),
              icon: const Icon(Icons.flip)),
          TooltipIconButton(
              message: "Flip vertically",
              onPressed: () => mirror(true),
              icon: Transform.rotate(
                angle: pi / 2,
                child: const Icon(Icons.flip),
              )),
          const Divider(),
          TooltipIconButton(
            message: "Rotate clockwise",
              onPressed: () => rotate(false),
              icon: const Icon(Icons.rotate_90_degrees_cw_outlined)),
          TooltipIconButton(
              message: "Rotate counter-clockwise",
              onPressed: () => rotate(true),
              icon: const Icon(Icons.rotate_90_degrees_ccw)),
        ],
      ),
    );
  }
}
