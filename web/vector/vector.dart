library vector;

import 'dart:math';

class Vector {
  final num x, y;
  num _length;

  Vector(this.x, this.y);

  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator -(Vector other) => new Vector(x - other.x, y - other.y);
  operator *(num scalar) => new Vector(x * scalar, y * scalar);
  operator /(num scalar) => new Vector(x / scalar, y / scalar);

  Vector dot(Vector other) => new Vector(x * other.x, y * other.y);
  Vector normalized() {
    var len = length();
    return new Vector(x / len, y / len);
  }
  
  num length() {
    if (_length == null) {
      _length = sqrt(x * x + y * y);
    }
    return _length;
  }
  
  toString() => 'Vector($x, $y)';
}