

int mapRange(int x, int min, int max, int newMin, int newMax) {
  double div = x/(max-min);

  return (div*(newMax-newMin)).round();
}