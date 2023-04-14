
List<int> intToBytes(int i) {

  int mask = 0xFF;

  List<int> out = [];

  for (int offset = 24; offset >= 0; offset -= 8) {
    out.add(i & (mask << offset));
  }

  return out;

}

int bytesToInt(List<int> list) {

  int out = 0;

  for (int i = 0; i < 4; i++) {
    out += list[i] << ((3-i)*8);
  }
  
  return out;

}