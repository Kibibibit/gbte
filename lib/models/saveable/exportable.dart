import 'package:gbte/models/saveable/saveable.dart';

abstract class Exportable extends Saveable {
  List<int> export();
}