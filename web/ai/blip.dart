part of ai;

class Blip extends Stimulation {
  final Vector delta;
  final num radius;
  
  Blip(this.delta, this.radius);
  
  toString() => 'Blip(delta=$delta, radius=$radius)';
}