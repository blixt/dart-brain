part of space;

class Blip extends Stimulation {
  /// The relative position of the blip.
  final Vector delta;
  /// The size of the blip.
  final num radius;

  Blip(this.delta, this.radius);

  toString() => 'Blip(delta=$delta, radius=$radius)';
}