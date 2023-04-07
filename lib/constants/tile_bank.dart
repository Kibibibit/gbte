import 'package:gbte/constants/palette_bank.dart';

abstract class TileBank {
  static const int sprite = 0;
  static const int shared = 1;
  static const int background = 2;

  static int toPaletteBank(int i) {
    switch (i) {
      case sprite:
        return PaletteBank.sprite;
      case background:
        return PaletteBank.background;
      case shared:
        return PaletteBank.shared;
      default:
        return -1;
    }
  }
}
