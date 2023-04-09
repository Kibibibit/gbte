import 'package:gbte/globals/events.dart';
import 'package:gbte/globals/globals.dart';
import 'package:gbte/models/app_event.dart';
import 'package:gbte/models/gbc_color.dart';

class PaletteAppEvent extends AppEvent {
  final int paletteIndex;
  final int colorIndex;
  final GBCColor previousColor;
  final GBCColor nextColor;

  const PaletteAppEvent(
      {required this.paletteIndex,
      required this.colorIndex,
      required this.previousColor,
      required this.nextColor})
      : super(AppEventType.palette);

  void _setPalette(GBCColor color) {
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
