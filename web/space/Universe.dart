part of space;

class Universe extends IterableBase<Entity> {
  static const num BLIP_RANGE = 200;

  final List<Entity> _entities = <Entity>[];
  final Vector size;

  Universe(this.size);

  /// An iterator over the entities.
  Iterator<Entity> get iterator => _entities.iterator;

  addEntity(Entity entity) {
    print('[universe.addEntity] $entity');
    _entities.add(entity);
  }

  Vector _matrixTimesVector(List<num> matrix, Vector vector) {
    return new Vector(vector.x * matrix[0] + vector.y * matrix[1],
                      vector.x * matrix[2] + vector.y * matrix[3]);
  }

  step() {
    var rand = new Random();

    // Movement.
    for (Entity entity in _entities) {
      entity.position += entity.velocity;

      // Wrap entities around the universe.
      if (entity.position.x - entity.radius > size.x) {
        entity.position -= new Vector(size.x + entity.radius * 2, 0);
      } else if (entity.position.x + entity.radius < 0) {
        entity.position += new Vector(size.x + entity.radius * 2, 0);
      }

      if (entity.position.y - entity.radius > size.y) {
        entity.position -= new Vector(0, size.y + entity.radius * 2);
      } else if (entity.position.y + entity.radius < 0) {
        entity.position += new Vector(0, size.y + entity.radius * 2);
      }
    }

    // Brains.
    for (Entity entity in _entities.where((e) => e.brain != null)) {
      var angle = entity.orientation;

      // A matrix for rotating vectors according to current orientation.
      var rot = [cos(angle), sin(angle),
                 -sin(angle), cos(angle)];

      // Loop through all other entities.
      for (Entity other in _entities) {
        if (other == entity) continue;

        // Get the relative vector between brain and other entity, and rotate it.
        var delta = _matrixTimesVector(rot, other.position - entity.position);

        // Apply noise to the relative vector.
        delta += new Vector(rand.nextDouble() - 0.5, rand.nextDouble() - 0.5) / 10;

        // Only let the brain know about entities that are close enough.
        if (delta.length <= BLIP_RANGE) {
          entity.brain.stimulations.stimulate(new Blip(delta, other.radius));
        }
      }

      entity.brain.step();
    }
  }
}