part of ai;

class World implements Iterable<Entity> {
  final List<Entity> _entities = <Entity>[];
  
  /// An iterator over the entities.
  Iterator<Entity> get iterator => _entities.iterator;

  addEntity(Entity entity) {
    print('[world.addEntity] $entity');
    _entities.add(entity);
  }
  
  step() {
    for (Brain brain in _entities.where((e) => e is Brain)) {
      for (var entity in _entities) {
        if (entity == brain) continue;
        brain.stimulations.stimulate(new Blip.between(brain, entity));
      }
      brain._step();
    }
  }
}