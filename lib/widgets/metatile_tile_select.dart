import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/widgets/dialog/tile_select_dialog.dart';
import 'package:gbte/widgets/tile_display.dart';

class MetatileTileSelect extends StatelessWidget {
  final int metatileIndex;

  final void Function(int tile, int index) onChange;

  const MetatileTileSelect({super.key, required this.metatileIndex, required this.onChange});

  Metatile get metatile => Globals.metatiles[metatileIndex];


  void onClick(int index, BuildContext context) async {
    int tileIndex = await showDialog(context: context, builder: (context) => const TileSelectDialog()) ?? metatile.tiles[index];
    onChange(tileIndex,index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.count(
          crossAxisCount: metatile.size,
          children: List.generate(
            metatile.size * metatile.size,
            (index) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onClick(index, context),
                child: TileDisplay(
                    tiles: [metatile.tiles[index]],
                    metatileSize: 1,
                    primaryColor: 0,
                    secondaryColor: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
