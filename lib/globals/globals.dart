import 'dart:io';

import 'package:gbte/constants/constants.dart';
import 'package:gbte/models/data_structures/matrix2d.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/tile.dart';

class Globals {
  static int _tileIndex(int index, int bank) =>
      (Constants.tileBankSize * bank) + index;

  static int spriteTileIndex(int index) => _tileIndex(index, 0);

  static int sharedTileIndex(int index) => _tileIndex(index, 1);

  static int backgroundTileIndex(int index) => _tileIndex(index, 2);

  static List<Tile> tiles = List.generate(Constants.tileCount, (_) => Tile());

  static int _paletteIndex(int index, int bank) =>
      (Constants.paletteBankSize * bank) + index;

  static int spritePaletteIndex(int index) => _paletteIndex(index, 0);

  static int backgroundPaletteIndex(int index) => _paletteIndex(index, 1);

  static List<Palette> palettes =
      List.generate(Constants.paletteCount, (_) => Palette.defaultPalette());

  static List<int> tilePalettes = List.generate(Constants.tileCount,
      (index) => index < Constants.tileBankSize * 2 ? 0 : 8);

  static List<String> paletteNames = List.generate(
      Constants.paletteCount,
      (index) => index < Constants.paletteBankSize
          ? "SPR $index"
          : "BKG ${index - 8}");
    
  static Matrix2D? copyBuffer;

  static String page = Constants.tilePage;

  static File? saveLocation;

  static bool saved = false;

  static List<Metatile> metasprites = [];
  static List<Metatile> metatiles = [];

  static void newFile() {
    tiles = List.generate(Constants.tileCount, (_) => Tile());
    palettes =
        List.generate(Constants.paletteCount, (_) => Palette.defaultPalette());
    tilePalettes = List.generate(Constants.tileCount,
        (index) => index < Constants.tileBankSize * 2 ? 0 : 8);
    paletteNames = List.generate(
        Constants.paletteCount,
        (index) => index < Constants.paletteBankSize
            ? "SPR $index"
            : "BKG ${index - 8}");
    saveLocation = null;
    saved = false;

    copyBuffer = null;

    metasprites = [];
    metatiles = [];
  }
}
