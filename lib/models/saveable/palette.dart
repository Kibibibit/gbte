import 'dart:typed_data';

import 'package:gbte/models/saveable/exportable.dart';
import 'package:gbte/models/saveable/gbc_color.dart';
import 'package:gbte/models/saveable/saveable.dart';

class Palette extends Exportable {
  late List<GBCColor> colors;

  Palette({required this.colors})
      : assert(colors.length == 4, "Palette must have 4 colours");

  static Palette defaultPalette() {
    return Palette(colors: [
      GBCColor(r: 31, g: 31, b: 31),
      GBCColor(r: 20, g: 20, b: 20),
      GBCColor(r: 10, g: 10, b: 10),
      GBCColor(r: 0, g: 0, b: 0),
    ]);
  }

  @override
  void load(Uint8List data) {
    List<int> bytes = data.toList();
    int header = bytes.removeAt(0);

    assert(header == Saveable.paletteHeader, "Tried to load a palette with a non-palette value");

    for (int i = 0; i < 4; i++) {
      List<int> color = bytes.getRange(i*2, i*2 + 2).toList();
      colors[i].load(Uint8List.fromList(color));
    }
  }

  @override
  Uint8List save() {
    List<int> out = [];
    out.add(Saveable.paletteHeader);
    for (int i = 0; i < 4; i++) {
      out.addAll(colors[i].save());
    }

    return Uint8List.fromList(out);
  }
  
  @override
  List<int> export() {
    List<int> data = [];
    for (GBCColor color in colors) {
      data.addAll(color.export());
    }
    return data;
  }
  
}
