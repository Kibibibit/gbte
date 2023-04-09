import 'dart:async';

import 'package:gbte/globals/fileio.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event.dart';

class Events {
  static int _undoIndex = -1;

  static StreamController<int> tileEditStream =
      StreamController<int>.broadcast();
  static StreamController<String> loadStream =
      StreamController<String>.broadcast();
  static StreamController<AppEvent> appEventStream =
      StreamController<AppEvent>.broadcast();

  static final List<AppEvent> _eventQueue = [];

  static void updateTile(int tile) {
    tileEditStream.sink.add(tile);
  }

  static void load(String filename) {
    loadStream.sink.add(filename);
  }

  static void clearAppEventQueue() {
    _eventQueue.clear();
    _undoIndex = -1;
  }

  static void appEvent(AppEvent event) {
    Globals.saved = false;
    if (Globals.saveLocation != null) {
      FileIO.triggerLoadStream(Globals.saveLocation!);
    }
    while (_undoIndex < _eventQueue.length - 1) {
      _eventQueue.removeLast();
    }
    _eventQueue.add(event);
    _undoIndex++;
    if (_eventQueue.length > 100) {
      _eventQueue.removeAt(0);
    }
  }

  static void undoEvent() {
    if (_undoIndex >= 0) {
      AppEvent event = _eventQueue[_undoIndex];
      event.undoEvent();
      _undoIndex--;
      Globals.saved = false;
      if (Globals.saveLocation != null) {
        FileIO.triggerLoadStream(Globals.saveLocation!);
      }
    }
  }

  static void redoEvent() {
    if (_undoIndex < _eventQueue.length - 1) {
      _undoIndex++;
      AppEvent event = _eventQueue[_undoIndex];
      event.redoEvent();
      Globals.saved = false;
      if (Globals.saveLocation != null) {
        FileIO.triggerLoadStream(Globals.saveLocation!);
      }
    }
  }
}
