import 'dart:async';

import 'package:gbte/models/app_event.dart';

class Events {

  static StreamController<int> tileEditStream = StreamController<int>.broadcast();
  static StreamController<String> loadStream = StreamController<String>.broadcast();

  static StreamController<AppEvent> appEventStream = StreamController<AppEvent>.broadcast();

  static final List<AppEvent> _eventQueue = [];

  static void updateTile(int tile) {
    tileEditStream.sink.add(tile);
  }

  static void load(String filename) {
    loadStream.sink.add(filename);
  }

  static void appEvent(AppEvent event) {
    _eventQueue.insert(0, event);
    if (_eventQueue.length > 100) {
      _eventQueue.removeLast();
    }
  }

  static void undoEvent() {
    if (_eventQueue.isNotEmpty) {
      print("Undoing!");
      AppEvent event = _eventQueue.removeAt(0);
      event.undoEvent();
    }
  }


}