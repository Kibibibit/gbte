
List<T> removeNullElements<T>(List<T?> list) {
  List<T> output = [];
  for (T? item in list) {
    if (item != null) {
      output.add(item);
    }
  }
  return output;
}