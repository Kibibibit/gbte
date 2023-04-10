
int wrapValue(int x, int min, int max) {
  return ((x-min) % (max-min)) + min;
}