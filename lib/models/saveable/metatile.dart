import 'dart:typed_data';

import 'package:gbte/models/saveable/saveable.dart';

class Metatile extends Saveable {

  final int size;
  final List<int> tiles;

  Metatile(this.size, this.tiles);

  @override
  List<int> export() {
    // TODO: implement export
    throw UnimplementedError();
  }

  @override
  void load(Uint8List data) {
    // TODO: implement load
  }

  @override
  Uint8List save() {
    // TODO: implement save
    throw UnimplementedError();
  }
  
}