library vector;

import 'dart:math';

class Vector {
  final num x, y;

  Vector(this.x, this.y);

  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator -(Vector other) => new Vector(x - other.x, y - other.y);
  operator *(num scalar) => new Vector(x * scalar, y * scalar);
  operator /(num scalar) => new Vector(x / scalar, y / scalar);

  Vector dot(Vector other) => new Vector(x * other.x, y * other.y);
  Vector normalized() {
    var len = length();
    new Vector(x / len, y / len);
  }
  
  num length() {
    return sqrt(x * x + y * y);
  }
  
  toString() => 'Vector($x, $y)';
}