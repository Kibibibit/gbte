extension ToBytes on int {
  String toByteString([int? bytes]) {
    String radix = toRadixString(16).toUpperCase();

    if (bytes == null) {
      int len = radix.length;
      while (len == 0 || len % 2 == 1) {
        len++;
      }
      radix = radix.padLeft(len, "0");
    } else {
      radix = radix.padLeft(bytes * 2, "0");
    }

    return "0x$radix";
  }
}
