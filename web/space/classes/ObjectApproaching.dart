part of space;

class ObjectApproaching extends Stimulation {
  final int objectId;
  final Vector delta;
  final Vector velocity;
  final num approachSpeed;
  
  ObjectApproaching(this.objectId, this.delta, this.velocity, this.approachSpeed);
  
  toString() => 'ObjectApproaching(objectId=$objectId, delta=$delta, velocity=$velocity, approachSpeed=$approachSpeed)';
}