part of space;

class Entity {
  final Brain brain;
  Vector position;
  Vector velocity;
  num orientation;
  num radius;
  
  Entity(this.position, {this.brain: null, this.orientation: 0, this.radius: 3, this.velocity}) {
    if (velocity == null) {
      velocity = new Vector(0, 0);
    }
  }
  
  Vector deltaTo(Entity other) {
    return other.position - position;
  }
  
  toString() => 'Entity(position=$position, velocity=$velocity, radius=$radius, brain=$brain)';
}