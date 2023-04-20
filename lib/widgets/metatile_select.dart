import 'package:flutter/material.dart';
import 'package:gbte/helpers/extensions/to_bytes.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/widgets/tile_display.dart';

class MetatileSelect extends StatelessWidget {
  final List<Metatile> metatiles;
  final int selected;
  final void Function(int index) onChange;

  const MetatileSelect(
      {super.key, required this.selected, required this.onChange, required this.metatiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: metatiles.length,
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
                      index.toByteString(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 80,
                  child: TileDisplay(
                    tiles: metatiles[index].tiles,
                    metatileSize: metatiles[index].size,
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
