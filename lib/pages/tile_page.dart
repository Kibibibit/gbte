
import 'package:flutter/material.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/palette_select.dart';
import 'package:gbte/widgets/tile_display.dart';
import 'package:gbte/widgets/tile_select.dart';

class TilePage extends StatefulWidget {

  final int tileBank;
  final int paletteBank;

  const TilePage({super.key, required this.tileBank, required this.paletteBank});

  @override
  State<TilePage> createState() => _TilePageState();
}

class _TilePageState extends State<TilePage> {
  late int selectedTile;
  late int selectedPalette;
  late int primaryColor;
  late int secondaryColor;

  @override
  void initState() {
    super.initState();
    selectedTile = widget.tileBank*256;
    primaryColor = 2;
    secondaryColor = 0;
    selectedPalette = Globals.tilePalettes[selectedTile];
  }

  void selectTile(int tile) {
    setState(() {
      selectedTile = tile;
      selectedPalette = Globals.tilePalettes[tile];
    });
  }

  void selectPalette(int palette) {
    Globals.tilePalettes[selectedTile] = palette;
    setState(() {
      selectedPalette = palette;
    });
    Events.updateTile(selectedTile);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          TileDisplay(
            tiles: [selectedTile],
            metatileSize: 1,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            edit: true,
          ),
          SizedBox(width:250, child: PaletteSelect(
            paletteBank: widget.paletteBank,
            selectedPalette: selectedPalette,
            onSelect: (p)=>selectPalette(p),
          )),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: 160,
            child: TileSelect(
              onSelect: (t) => selectTile(t),
              selectedTile: selectedTile,
              tileBank: widget.tileBank,
            ),
          ),
        ],
      ),
    );
  }
}
