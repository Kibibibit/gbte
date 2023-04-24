import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/components/int_editing_controller.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/tile_bank.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/tile_app_event.dart';
import 'package:gbte/models/saveable/gbc_color.dart';
import 'package:gbte/models/app_event/palette_app_event.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/palette_editor.dart';
import 'package:gbte/widgets/tile_display.dart';
import 'package:gbte/widgets/tile_edit_buttons.dart';
import 'package:gbte/widgets/tile_select.dart';

class TilePage extends StatefulWidget {
  const TilePage({super.key});

  @override
  State<TilePage> createState() => _TilePageState();
}

class _TilePageState extends State<TilePage> {
  late int selectedTile;
  late int selectedPalette;
  late int primaryColor;
  late int secondaryColor;
  late int red;
  late int green;
  late int blue;
  int tileBank = TileBank.sprite;
  late GBCColor previousColor;

  late IntEditingController redController;
  late IntEditingController greenController;
  late IntEditingController blueController;

  late StreamSubscription<String> loadStream;
  late StreamSubscription<int> tileStream;

  void _previousColor() {
    setState(() {
      previousColor = GBCColor(r: red, g: green, b: blue);
    });
  }

  void onBankSelect(int? bank) {
    if (bank != null) {
      if (bank != tileBank) {
        selectTile(Constants.tileBankSize * bank);
        if (bank != TileBank.shared) {
          selectPalette(
              TileBank.toPaletteBank(bank) * Constants.paletteBankSize);
        }
      }
      setState(() {
        tileBank = bank;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTile = tileBank * Constants.tileBankSize;
    primaryColor = 2;
    secondaryColor = 0;
    selectedPalette = Globals.tilePalettes[selectedTile];
    loadStream = Events.loadStream.stream.listen((_) => loadColors());
    tileStream = Events.tileEditStream.stream.listen((_) => loadColors());
    redController = IntEditingController(max: 31);
    greenController = IntEditingController(max: 31);
    blueController = IntEditingController(max: 31);
    loadColors();

    _previousColor();
  }

  @override
  void dispose() {
    super.dispose();
    loadStream.cancel();
    tileStream.cancel();
  }

  void loadColors({bool updatedControllers = false}) {
    setState(() {
      red = Globals.palettes[selectedPalette].colors[primaryColor].r;
      green = Globals.palettes[selectedPalette].colors[primaryColor].g;
      blue = Globals.palettes[selectedPalette].colors[primaryColor].b;
      redController.text = red.toString();
      blueController.text = blue.toString();
      greenController.text = green.toString();
    });
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
      loadColors();
    });
    Events.updateTile(selectedTile);
  }

  void selectColorPrimary(int color) {
    setState(() {
      primaryColor = color;
    });
    loadColors();
  }

  void selectColorSecondary(int color) {
    setState(() {
      secondaryColor = color;
    });
  }

  void onChangeRed(int red) {
    Globals.palettes[selectedPalette].colors[primaryColor].r = red;
    loadColors();
  }

  void onChangeGreen(int green) {
    Globals.palettes[selectedPalette].colors[primaryColor].g = green;
    loadColors();
  }

  void onChangeBlue(int blue) {
    Globals.palettes[selectedPalette].colors[primaryColor].b = blue;
    loadColors();
  }

  void onChangeStart() {
    _previousColor();
  }

  void onChangeEnd() {
    Events.appEvent(PaletteAppEvent(
      paletteIndex: selectedPalette,
      colorIndex: primaryColor,
      previousColor: previousColor.save(),
      nextColor: GBCColor(r: red, g: green, b: blue).save(),
    ));
  }

  void onCopy() {
    Globals.copyBuffer = Globals.tiles[selectedTile].matrix.copy();
  }

  void onCut() {
    String prev = Globals.tiles[selectedTile].save();
    onCopy();
    setState(() {
      Globals.tiles[selectedTile] = Tile();
    });

    Events.appEvent(TileAppEvent(
        tileIndices: [selectedTile],
        previousTiles: [prev],
        nextTiles: [Tile().save()]));
  }

  void onPaste() {
    if (Globals.copyBuffer == null) return;
    String prev = Globals.tiles[selectedTile].save();
    setState(() {
      for (int y = 0; y < Tile.size; y++) {
        for (int x = 0; x < Tile.size; x++) {
          Globals.tiles[selectedTile].set(x, y, Globals.copyBuffer!.get(x, y));
        }
      }
    });
    Events.updateTile(selectedTile);
    Events.appEvent(TileAppEvent(
        tileIndices: [selectedTile],
        previousTiles: [prev],
        nextTiles: [Globals.tiles[selectedTile].save()]));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      onCopy: onCopy,
      onCut: onCut,
      onPaste: onPaste,
      page: Constants.tilePage,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TileEditButtons(
                tiles: [selectedTile],
                metatileSize: 1,
              ),
              TileDisplay(
                tiles: [selectedTile],
                metatileSize: 1,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                edit: true,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: 200,
                  child: TileDisplay(
                      tiles: List.generate(9, (_) => selectedTile),
                      metatileSize: 3,
                      primaryColor: primaryColor,
                      border: false,
                      secondaryColor: secondaryColor),
                ),
                PaletteEditor(
                  onChangeRed: onChangeRed,
                  onChangeGreen: onChangeGreen,
                  onChangeBlue: onChangeBlue,
                  onChangeStart: onChangeStart,
                  onChangeEnd: onChangeEnd,
                  redController: redController,
                  greenController: greenController,
                  blueController: blueController,
                  red: red,
                  green: green,
                  blue: blue,
                  selectedPalette: selectedPalette,
                  selectedPrimaryColor: primaryColor,
                  onChangePrimaryColor: selectColorPrimary,
                  selectedSecondaryColor: secondaryColor,
                  onChangeSecondaryColor: selectColorSecondary,
                  secondarySelect: true,
                  onChangePalette: selectPalette,
                  paletteBank: TileBank.toPaletteBank(tileBank),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 190),
              decoration: BoxDecoration(border: Border.all()),
              child: TileSelect(
                onSelect: (t) => selectTile(t),
                selectedTile: selectedTile,
                tileBank: tileBank,
                onBankSelect: onBankSelect,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
