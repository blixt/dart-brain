part of space;

class Entity {
  final Brain brain;
  /// The current absolute position of this entity.
  Vector position;
  /// The current velocity of this entity.
  Vector velocity;
  /// The angle at which this entity is oriented.
  num orientation;
  /// The size of this entity.
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