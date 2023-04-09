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
  
  @override
  void undoEvent() {
    for (int i = 0; i < tileIndices.length; i++) {
      int tileIndex = tileIndices[i];
      Tile previousTile = previousTiles[i];
      Globals.tiles[tileIndex] = previousTile;
      Events.updateTile(tileIndex);
    }
  }
}
