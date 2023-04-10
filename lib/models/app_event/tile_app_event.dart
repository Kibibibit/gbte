import 'dart:typed_data';

import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/app_event.dart';
import 'package:gbte/models/saveable/tile.dart';

class TileAppEvent extends AppEvent {
  final List<int> tileIndices;
  final List<Uint8List> previousTiles;
  final List<Uint8List> nextTiles;

  const TileAppEvent({
    required this.tileIndices,
    required this.previousTiles,
    required this.nextTiles,
  }) : super(AppEventType.tile);
  

  void _setTiles(List<Uint8List> from) {
    for (int i = 0; i < tileIndices.length; i++) {
      int tileIndex = tileIndices[i];
      Uint8List data = from[i];
      Tile newTile = Tile();
      newTile.load(data);
      Globals.tiles[tileIndex] = newTile;
      Events.updateTile(tileIndex);
    }
  }

  @override
  void undoEvent() {
    _setTiles(previousTiles);
  }
  
  @override
  void redoEvent() {
    _setTiles(nextTiles);
  }
}
