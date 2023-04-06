


double mapRangeToDouble(num x, num min, num max, num newMin, num newMax) {
  double div = x/(max-min);

  return (div*(newMax-newMin));
}


int mapRange(num x, num min, num max, int newMin, int newMax) => mapRangeToDouble(x, min, max, newMin, newMax).round();
