import 'package:gbte/models/palette.dart';
import 'package:gbte/models/tile.dart';

class Globals {

  static int _tileIndex(int index, int bank) => (256*bank) + index;

  static int spriteTileIndex(int index) => _tileIndex(index, 0);
  static int sharedTileIndex(int index) => _tileIndex(index, 1);
  static int backgroundTileIndex(int index) => _tileIndex(index, 2);

  static List<Tile> tiles = List.generate(256*3, (_) => Tile());

  static int _paletteIndex(int index, int bank) => (8*bank) + index;

  static int spritePaletteIndex(int index) => _paletteIndex(index, 0);
  static int backgroundPaletteIndex(int index) => _paletteIndex(index, 1);

  static List<Palette> palettes = List.generate(16, (_) => Palette.defaultPalette());


}