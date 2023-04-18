import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/widgets/tile_display.dart';

class MetatileSelect extends StatelessWidget {
  final int selected;
  final void Function(int index) onChange;

  const MetatileSelect(
      {super.key, required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: Globals.metasprites.length,
        itemBuilder: (context, index) => Material(
          color: selected == index ? Colors.lightBlue : Colors.transparent,
          child: InkWell(
            onTap: () => onChange(index),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      "$index",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 80,
                  child: TileDisplay(
                    tiles: Globals.metasprites[index].tiles,
                    metatileSize: Globals.metasprites[index].size,
                    border: false,
                    primaryColor: 2,
                    secondaryColor: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
