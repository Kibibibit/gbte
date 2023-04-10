import 'dart:typed_data';

import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event/app_event.dart';
import 'package:gbte/models/saveable/gbc_color.dart';

class PaletteAppEvent extends AppEvent {
  final int paletteIndex;
  final int colorIndex;
  final Uint8List previousColor;
  final Uint8List nextColor;

  const PaletteAppEvent(
      {required this.paletteIndex,
      required this.colorIndex,
      required this.previousColor,
      required this.nextColor})
      : super(AppEventType.palette);

  void _setPalette(Uint8List data) {
    GBCColor color = GBCColor(r: 0, g: 0, b: 0);
    color.load(data);
    Globals.palettes[paletteIndex].colors[colorIndex] = color;
    Events.updateTile(0);
  }

  @override
  void undoEvent() {
    _setPalette(previousColor);
  }
  
  @override
  void redoEvent() {
    _setPalette(nextColor);
  }
}
