import 'package:gbte/helpers/wrap_value.dart';

class Matrix2D {
  late final List<int> _data;
  late final int _width;
  late final int _height;

  Matrix2D(int width, int height) {
    _width = width;
    _height = height;
    _data = List.generate(_width * _height, (_) => 0);
  }

  int get width => _width;
  int get height => _height;

  int _index(int x, int y) {
    assert(x >= 0 && x < _width && y >= 0 && y < _height,
        "Invalid matrix $x,$y index for matrix of size ($_width, $_height)!");
    return (y * _width) + x;
  }

  int get(int x, int y) {
    return _data[_index(x, y)];
  }

  int getI(int i) {
    return _data[i];
  }

  void set(int x, int y, int value) {
    _data[_index(x, y)] = value;
  }

  void setI(int i, int value) {
    _data[i] = value;
  }

  Matrix2D copy() {
    Matrix2D out = Matrix2D(width, height);
    int i = 0;
    for (int v in _data) {
      out.setI(i, v);
      i++;
    }
    return out;
  }

  Matrix2D joinMatrix(MatrixAlignment alignment, Matrix2D other) {

    late int newWidth;
    late int newHeight;
    int widthMult = 0;
    int heightMult = 0;

    if (alignment == MatrixAlignment.bottom || alignment == MatrixAlignment.top) {
      assert(_width == other.width, "Matrices must be the same width when joining vertically");
      newWidth = width;
      newHeight = height + other.height;
      heightMult = 1;
    } else {
      assert(_height == other.height, "Matrices must be the same height when joining horizontally");
      newWidth = width + other.width;
      newHeight = height;
      widthMult = 1;
    }

    late Matrix2D a;
    late Matrix2D b;

    if (alignment == MatrixAlignment.bottom || alignment == MatrixAlignment.right) {
      a = copy();
      b = other.copy();
    } else {
      a = other.copy();
      b = copy();
    }

    Matrix2D out = Matrix2D(newWidth, newHeight);

    for (int x = 0; x < a.width; x++) {
      for (int y = 0; y < a.height; y++) {
        out.set(x, y, a.get(x,y));
      }
    }

    for (int x = 0; x < b.width; x++) {
      for (int y = 0; y < b.height; y++) {
        out.set(x + (a.width*widthMult), y + (a.height*heightMult), b.get(x,y));
      }
    }

    return out;
  }

  Matrix2D shunt(ShuntDirection direction) {
    int xOffset = 0;
    int yOffset = 0;
    switch(direction) {
      case ShuntDirection.up:
        yOffset = -1;
        break;
      case ShuntDirection.down:
        yOffset = 1;
        break;
      case ShuntDirection.left:
        xOffset = -1;
        break;
      case ShuntDirection.right:
        xOffset = 1;
        break;
    }

    Matrix2D out = Matrix2D(width, height);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        out.set(wrapValue(x+xOffset, 0, width), wrapValue(y+yOffset, 0, height),get(x,y));
      }
    }

    return out;

  }

  Matrix2D subMatrix(int x, int y, int subWidth, int subHeight) {
    Matrix2D out = Matrix2D(subWidth, subHeight);
    for (int xx = 0; xx < subWidth; xx++) {
      for (int yy = 0; yy < subHeight; yy++) {
        int px = xx+x;
        int py = yy+y;
        if (px >= 0 && px < width && py >= 0 && py < height) {
          out.set(xx, yy, get(px, py));
        } else {
          out.set(xx,yy,0);
        }
      }
    }
    return out;
  }

  Matrix2D mirror(bool vertical) {

    Matrix2D out = Matrix2D(width, height);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int ox = x;
        int oy = y;
        if (vertical) {
          oy = height-1-y;
        } else {
          ox = width-1-x;
        }
        out.set(ox, oy, get(x, y));
      }
    }

    return out;
  }

  Matrix2D rotate(bool counterClockWise) {

    late Matrix2D out;

    if (counterClockWise) {
      out = mirror(false);
      out = out.transpose();
    } else {
      out = transpose();
      out = out.mirror(false);
    }

    return out;

  }

  Matrix2D transpose() {
    Matrix2D out = Matrix2D(width, height);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        out.set(y, x, get(x, y));
      }
    }
    return out;
  }


  @override
  String toString() {
    String out = "\n";
    for (int y = 0; y < height; y++) {
      String row = "|";
      for (int x = 0; x < width; x++) {
        row = "$row ${get(x,y).toRadixString(16)}";
      }
      row = "$row |";
      out = "$out$row\n";
    }
    return out;
  }

}

enum MatrixAlignment {
  top,
  bottom,
  left,
  right,
}


enum ShuntDirection {
  up,
  down,
  left,
  right,
}