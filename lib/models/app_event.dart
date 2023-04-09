abstract class AppEvent {

  final AppEventType dtype;

  const AppEvent(this.dtype);

  void undoEvent();

}

enum AppEventType {
  palette,
  tile,
}