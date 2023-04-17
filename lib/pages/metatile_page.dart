import 'package:flutter/material.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/color_select.dart';
import 'package:gbte/widgets/metatile_tile_select.dart';
import 'package:gbte/widgets/size_selector.dart';
import 'package:gbte/widgets/tile_display.dart';
import 'package:gbte/widgets/tile_edit_buttons.dart';

class MetatilePage extends StatefulWidget {
  const MetatilePage({super.key});

  @override
  State<MetatilePage> createState() => _MetatilePageState();
}

class _MetatilePageState extends State<MetatilePage> {
  late int primaryColor;
  late int secondaryColor;
  late int selectedMetatile;
  late int hoveredTile;

  Metatile? get metatile =>
      Globals.metasprites.isNotEmpty ? Globals.metasprites[selectedMetatile] : null;

  void createMetatile() {
    Globals.metasprites.add(Metatile(2, [0, 1, 2, 3]));
    setState(() {
      selectedMetatile = Globals.metasprites.length - 1;
      
    });
  }

  @override
  void initState() {
    super.initState();
    primaryColor = 2;
    secondaryColor = 0;
    selectedMetatile = 0;
    hoveredTile = 0;
  }

  void selectColorPrimary(int color) {
    setState(() {
      primaryColor = color;
    });
  }

  void selectColorSecondary(int color) {
    setState(() {
      secondaryColor = color;
    });
  }

  void onHover(int index) {
    setState(() {
      hoveredTile = index;
    });
  }

  void metatileUpdate(int tile, int index) {
    setState(() {
      metatile!.tiles[index] = tile;
    });
  }

  void onSizeChange(int size) {
    setState(() {
      metatile!.size = size;
      while (metatile!.tiles.length < size*size) {
        metatile!.tiles.add(metatile!.tiles.last+1);
      }
      while (metatile!.tiles.length > size*size) {
        metatile!.tiles.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: metatile == null
          ? Center(
              child: Column(
                children: [
                  const Text("No metatiles!"),
                  TextButton(
                      onPressed: () => createMetatile(),
                      child: const Text("Create metatile"))
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TileEditButtons(
                      tiles: metatile!.tiles,
                      metatileSize: metatile!.size,
                    ),
                    TileDisplay(
                      tiles: metatile!.tiles,
                      metatileSize: metatile!.size,
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                      onHover: onHover,
                      edit: true,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MetatileTileSelect(
                        onChange: metatileUpdate,
                        metatileIndex: selectedMetatile,
                      ),
                      SizeSelector(value: metatile!.size, onChange: onSizeChange),
                      SizedBox(
                        height: 50,
                        child: ColorSelect(
                          onSelectPrimary: selectColorPrimary,
                          onSelectSecondary: selectColorSecondary,
                          palette: Globals.tilePalettes[hoveredTile],
                          selectedPrimaryColor: primaryColor,
                          selectedSecondaryColor: secondaryColor,
                          secondarySelect: true,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
