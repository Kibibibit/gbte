
abstract class Saveable {

  static const String paletteHeader = "PALETTE";
  static const String tileHeader = "TILE";
  static const String metatileHeader = "METATILE";

  String save();
  void load(String data);

}