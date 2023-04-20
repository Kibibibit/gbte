import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/tile_bank.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/tile_app_event.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/color_select.dart';
import 'package:gbte/widgets/metatile_select.dart';
import 'package:gbte/widgets/metatile_tile_select.dart';
import 'package:gbte/widgets/size_selector.dart';
import 'package:gbte/widgets/tile_display.dart';
import 'package:gbte/widgets/tile_edit_buttons.dart';

class MetatilePage extends StatefulWidget {
  const MetatilePage(
      {super.key,
      required this.metatiles,
      required this.isMetatiles,
      required this.page});

  final List<Metatile> metatiles;
  final bool isMetatiles;
  final String page;

  @override
  State<MetatilePage> createState() => _MetatilePageState();
}

class _MetatilePageState extends State<MetatilePage> {
  late int primaryColor;
  late int secondaryColor;
  late int selectedMetatile;
  late int hoveredTile;

  Metatile? get metatile =>
      widget.metatiles.isNotEmpty ? widget.metatiles[selectedMetatile] : null;

  void createMetatile() {
    int offset = widget.isMetatiles ? Constants.tileBankSize * 2 : 0;
    widget.metatiles
        .add(Metatile(2, [offset + 0, offset + 1, offset + 2, offset + 3]));
    setState(() {
      selectedMetatile = widget.metatiles.length - 1;
    });
  }

  void deleteMetatile(int index) {
    setState(() {
      widget.metatiles.removeAt(index);
      while (selectedMetatile >= widget.metatiles.length &&
          selectedMetatile != 0) {
        selectedMetatile--;
      }
    });
  }

  void selectTile(int tile) {
    setState(() {
      selectedMetatile = tile;
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
      while (metatile!.tiles.length < size * size) {
        metatile!.tiles.add(metatile!.tiles.last + 1);
      }
      while (metatile!.tiles.length > size * size) {
        metatile!.tiles.removeLast();
      }
    });
  }

  void onPaste() {
    if (Globals.copyBuffer == null) return;
    if (widget.metatiles.isEmpty) createMetatile();

    List<Uint8List> previousTiles = metatile!.toBytes();

    Matrix2D matrix = metatile!.createMatrix();

    for (int y = 0; y < matrix.height; y++) {
      for (int x = 0; x < matrix.width; x++) {
        if (x < Globals.copyBuffer!.width && y < Globals.copyBuffer!.height) {
          matrix.set(x, y, Globals.copyBuffer!.get(x, y));
        } else {
          matrix.set(x, y, 0);
        }
      }
    }
    setState(() {
      metatile!.fromMatrix(matrix);
    });

    Events.appEvent(TileAppEvent(
        tileIndices: metatile!.tiles,
        previousTiles: previousTiles,
        nextTiles: metatile!.toBytes()));
  }

  void onCopy() {
    if (widget.metatiles.isNotEmpty) {
      Globals.copyBuffer = widget.metatiles[selectedMetatile].createMatrix();
    }
  }

  void onCut() {
    if (widget.metatiles.isNotEmpty) {
      List<Uint8List> previousTiles = metatile!.toBytes();

      onCopy();
      setState(() {
        for (int index in metatile!.tiles) {
          Globals.tiles[index] = Tile();
        }
      });

      Events.appEvent(TileAppEvent(
          tileIndices: metatile!.tiles,
          previousTiles: previousTiles,
          nextTiles: metatile!.toBytes()));
    }
  }

  String get label => widget.isMetatiles ? "metatile" : "metasprite";

  Widget createButton() => TextButton(
      onPressed: () => createMetatile(), child: Text("Create $label"));

  @override
  Widget build(BuildContext context) {
    return BasePage(
      onCopy: onCopy,
      onPaste: onPaste,
      onCut: onCut,
      page: widget.page,
      child: metatile == null
          ? Center(
              child: Column(
                children: [Text("No ${label}s!"), createButton()],
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
                      Column(
                        children: [
                          MetatileTileSelect(
                            metatiles: widget.metatiles,
                            tileBank: widget.isMetatiles
                                ? TileBank.background
                                : TileBank.sprite,
                            onChange: metatileUpdate,
                            metatileIndex: selectedMetatile,
                          ),
                          SizeSelector(
                              value: metatile!.size, onChange: onSizeChange),
                        ],
                      ),
                      TextButton(
                          onPressed: () => deleteMetatile(selectedMetatile),
                          child: const Text("Delete")),
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
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      createButton(),
                      Flexible(
                        child: MetatileSelect(
                          metatiles: widget.metatiles,
                          selected: selectedMetatile,
                          onChange: selectTile,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
