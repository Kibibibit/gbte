import 'package:flutter/material.dart';
import 'package:gbte/widgets/tile_display.dart';

class TileSelect extends StatelessWidget {

  final void Function(int) onSelect;
  final int tileBank;
  final int selectedTile;

  const TileSelect({super.key, required this.onSelect, required this.selectedTile, required this.tileBank});

  
  int _index(int i) => (tileBank*256) + i;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 256,
      itemBuilder: (context, index) => Material(
        color: selectedTile == _index(index) ? Colors.grey : Colors.transparent,
        child: InkWell(
          onTap: () => onSelect(_index(index)),
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
                  tiles: [_index(index)],
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
