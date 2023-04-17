import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gbte/constants/constants.dart';
import 'package:gbte/globals/events.dart';
import 'package:gbte/models/saveable/metatile.dart';
import 'package:gbte/models/saveable/palette.dart';
import 'package:gbte/models/saveable/tile.dart';
import 'package:gbte/widgets/dialog/unsaved_changes_dialog.dart';

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
  static File? saveLocation;
  static bool saved = false;

  static List<Metatile> metatiles = [];

  static const String exportToOneFile = "exportToOneFile";
  static const String tilesInOneFile = "tilesInOneFile";
  static const String palettesInOneFile = "palettesInOneFile";
  static const String exportSpritePaletteIndex = "exportSpritePalettes";
  static const String exportBackgroundPaletteIndex = "exportBackgroundPalettes";
  static const String exportSpriteTileIndex = "exportSpriteTiles";
  static const String exportSharedTileIndex = "exportSharedTiles";
  static const String exportBackgroundTileIndex = "exportBackgroundTiles";
  static const String exportSprites = "exportSprites";
  static const String exportShared = "exportShared";
  static const String exportBackground = "exportBackground";
  static const String exportPalettesSprite = "exportPalettesSprites";
  static const String exportPalettesBackground = "exportPalettesBackground";

  static const String exportOneFileLocation = "exportOneFileLocation";
  static const String exportTilesLocation = "exportTilesLocation";
  static const String exportPalettesLocation = "exportPalettesLocation";

  static const String exportSpriteTilesLocation = "exportSpritesTilesLocation";
  static const String exportSharedTilesLocation = "exportSharedTilesLocation";
  static const String exportBackgroundTilesLocation =
      "exportBackgroundTilesLocation";

  static const String exportSpritePalettesLocation =
      "exportSpritePalettesLocation";
  static const String exportBackgroundPalettesLocation =
      "exportBackgroundPalettesLocation";

  static Map<String, bool> exportFlags = {
    exportToOneFile: false,
    tilesInOneFile: true,
    palettesInOneFile: true,
    exportSprites: true,
    exportShared: true,
    exportBackground: true,
    exportPalettesSprite: true,
    exportPalettesBackground: true,
  };

  static Map<String, int> exportRanges = {
    exportSpritePaletteIndex: 0,
    exportBackgroundPaletteIndex: 0,
    exportSpriteTileIndex: 0,
    exportSharedTileIndex: 0,
    exportBackgroundTileIndex: 0,
  };

  static Map<String, String> exportStrings = {
    exportOneFileLocation: "",
    exportTilesLocation: "",
    exportPalettesLocation: "",
    exportSpriteTilesLocation: "",
    exportSharedTilesLocation: "",
    exportBackgroundTilesLocation: "",
    exportBackgroundPalettesLocation: "",
    exportSpritePalettesLocation: "",
  };

  static void newFile(BuildContext context) async {

    if (!saved) {
      if (context.mounted) {
        bool cont = await showDialog(context: context, builder: (context) => const UnsavedChangesDialog()) ?? false;
        if (!cont) {
          return;
        }
      }
    }

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

    exportFlags = {
      exportToOneFile: false,
      tilesInOneFile: true,
      palettesInOneFile: true,
      exportSprites: true,
      exportShared: true,
      exportBackground: true,
      exportPalettesSprite: true,
      exportPalettesBackground: true,
    };
    exportRanges = {
      exportSpritePaletteIndex: 0,
      exportBackgroundPaletteIndex: 0,
      exportSpriteTileIndex: 0,
      exportSharedTileIndex: 0,
      exportBackgroundTileIndex: 0,
    };
    exportStrings = {
      exportOneFileLocation: "",
      exportTilesLocation: "",
      exportPalettesLocation: "",
      exportSpriteTilesLocation: "",
      exportSharedTilesLocation: "",
      exportBackgroundTilesLocation: "",
      exportBackgroundPalettesLocation: "",
      exportSpritePalettesLocation: "",
    };
    metatiles = [];
    Events.load("");
    Events.clearAppEventQueue();
  }
}
