import 'dart:async';

class Events {

  static StreamController<int> tileEditStream = StreamController<int>.broadcast();
  static StreamController<String> loadStream = StreamController<String>.broadcast();

  static void updateTile(int tile) {
    tileEditStream.sink.add(tile);
  }

  static void load(String filename) {
    loadStream.sink.add(filename);
  }


}