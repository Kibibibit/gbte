abstract class AppEvent {

  final AppEventType dtype;

  const AppEvent(this.dtype);

  void undoEvent();
  void redoEvent();

}

enum AppEventType {
  palette,
  tile,
}