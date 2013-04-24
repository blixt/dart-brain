part of ai;

class Entity {
  Vector position;
  num radius;
  
  Entity(this.position, this.radius);
  
  Vector deltaTo(Entity other) {
    return other.position - position;
  }
  
  toString() => 'Entity(position=$position, radius=$radius)';
}