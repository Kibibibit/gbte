abstract class Exports {
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

  static void newFile() {
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
  }
}
