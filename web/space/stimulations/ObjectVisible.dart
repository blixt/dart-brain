part of space;

class ObjectVisible extends Stimulation {
  final int objectId;
  final Vector delta;
  final Vector velocity;
  final num radius;
  final int staleness;

  ObjectVisible(this.objectId, this.delta, this.velocity, this.radius, this.staleness);
  
  toString() => 'ObjectVisible(objectId=$objectId, delta=$delta, velocity=$velocity, radius=$radius, staleness=$staleness)';
}