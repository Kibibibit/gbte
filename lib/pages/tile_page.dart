import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/constants/tile_bank.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/gbc_color.dart';
import 'package:gbte/models/palette_app_event.dart';
import 'package:gbte/pages/base_page.dart';
import 'package:gbte/widgets/palette_editor.dart';
import 'package:gbte/widgets/tile_display.dart';
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
    loadColors();
    _previousColor();
  }

  @override
  void dispose() {
    super.dispose();
    loadStream.cancel();
    tileStream.cancel();
  }

  void loadColors() {
    setState(() {
      red = Globals.palettes[selectedPalette].colors[primaryColor].r;
      green = Globals.palettes[selectedPalette].colors[primaryColor].g;
      blue = Globals.palettes[selectedPalette].colors[primaryColor].b;
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
    Events.appEvent(PaletteAppEvent(paletteIndex: selectedPalette, colorIndex: primaryColor, previousColor: previousColor, nextColor: GBCColor(r: red, g: green, b: blue)));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TileDisplay(
            tiles: [selectedTile],
            metatileSize: 1,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            edit: true,
          ),
          PaletteEditor(
            onChangeRed: onChangeRed,
            onChangeGreen: onChangeGreen,
            onChangeBlue: onChangeBlue,
            onChangeStart: onChangeStart,
            onChangeEnd:  onChangeEnd,
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
