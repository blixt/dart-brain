import 'ai/ai.dart';

class Entity {
  final Brain brain;
  Vector position;
  Vector velocity;
  num radius;
  
  Entity(this.position, {this.brain: null, this.radius: 3, this.velocity}) {
    if (velocity == null) {
      velocity = new Vector(0, 0);
    }
  }
  
  Vector deltaTo(Entity other) {
    return other.position - position;
  }
  
  toString() => 'Entity(position=$position, velocity=$velocity, radius=$radius, brain=$brain)';
}

class Universe implements Iterable<Entity> {
  const num BLIP_RANGE = 200;
  
  final List<Entity> _entities = <Entity>[];
  final Vector size;
  
  Universe(this.size);
  
  /// An iterator over the entities.
  Iterator<Entity> get iterator => _entities.iterator;

  addEntity(Entity entity) {
    print('[universe.addEntity] $entity');
    _entities.add(entity);
  }
  
  step() {
    // Movement.
    for (Entity entity in _entities) {
      entity.position += entity.velocity;
      
      // Wrap entities around the universe.
      if (entity.position.x - entity.radius > size.x) {
        entity.position -= new Vector(size.x, 0);
      } else if (entity.position.x + entity.radius < 0) {
        entity.position += new Vector(size.x, 0);
      }
      
      if (entity.position.y - entity.radius > size.y) {
        entity.position -= new Vector(0, size.y);
      } else if (entity.position.y + entity.radius < 0) {
        entity.position += new Vector(0, size.y);
      }
    }
    
    // Brains.
    for (Entity entity in _entities.where((e) => e.brain != null)) {
      for (Entity other in _entities) {
        if (other == entity) continue;
        Vector delta = other.position - entity.position;
        if (delta.length() <= BLIP_RANGE) {
          entity.brain.stimulations.stimulate(new Blip(delta, other.radius));
        }
      }
      entity.brain.step();
    }
  }
}