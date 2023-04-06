import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelect extends StatelessWidget {

  final void Function(int) onSelect;

  final int selectedTile;

  const TileSelect({super.key, required this.onSelect, required this.selectedTile});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Globals.tiles.length,
      itemBuilder: (context, index) => Material(
        color: selectedTile == index ? Colors.grey : Colors.transparent,
        child: InkWell(
          onTap: () => onSelect(index),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                child: Center(
                  child: Text("$index",style:const TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(
                width: 100,
                child: TileDisplay(
                  tiles: [index],
                  metatileSize: 1,
                  primaryColor: 2,
                  secondaryColor: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
