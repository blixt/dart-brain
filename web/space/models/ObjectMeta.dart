part of space;

class ObjectMeta {
  final int id;
  /// The most recent location info of this object.
  Blip _blip;
  /// The delta between the last known delta and the delta before that.
  Vector _velocity = new Vector(0, 0);
  /// The number of steps that the object has not been updated.
  int _inactivity = 0;
  
  /// The calculated velocity of the object.
  Vector get velocity => _velocity;
  
  // Id is passed in rather than generated because the id should stay local to
  // the code that is using it.
  ObjectMeta(this.id, this._blip);
  
  /// Gets the most recent location info of this object.
  Blip get blip => _blip;
  
  /// Sets the location info of this object.
  set blip(Blip value) {
    _velocity = value.delta - _blip.delta;
    _blip = value;
    _inactivity = 0;
  }
  
  /// The number of steps that the object hasn't been updated.
  int get inactivity => _inactivity;
  
  /// The delta of the object assuming it keeps moving as it did previously.
  Vector getProjectedDelta() => _blip.delta + _velocity * _inactivity;
  
  int step() => ++_inactivity;
  
  toString() => 'ObjectMeta(id=$id, blip=$_blip, velocity=$velocity)';
}