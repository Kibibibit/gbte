import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event.dart';
import 'package:gbte/models/tile.dart';

class TileAppEvent extends AppEvent {
  final List<int> tileIndices;
  final List<Tile> previousTiles;
  final List<Tile> nextTiles;

  const TileAppEvent({
    required this.tileIndices,
    required this.previousTiles,
    required this.nextTiles,
  }) : super(AppEventType.tile);
  

  void _setTiles(List<Tile> from) {
    for (int i = 0; i < tileIndices.length; i++) {
      int tileIndex = tileIndices[i];
      Tile newTile = from[i];
      Globals.tiles[tileIndex] = newTile.copy();
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
