import 'dart:async';

class Events {

  static StreamController<int> tileEditStream = StreamController<int>.broadcast();


  static void updateTile(int tile) {
    tileEditStream.sink.add(tile);
  }


}