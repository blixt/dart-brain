part of ai;

class Blip extends Stimulation {
  final Vector delta;
  final num radius;
  
  Blip(this.delta, this.radius);
  Blip.between(Entity entity, Entity other) : this(other.position - entity.position, entity.radius);
  
  toString() => 'Blip(delta=$delta, radius=$radius)';
}