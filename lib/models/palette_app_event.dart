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

  @override
  void undoEvent() {
    // TODO: implement undoEvent
  }
}
