part of space;

class DetectorReactor extends Reactor {
  const int MAX_DISTANCE = 10;
  const int MAX_INACTIVITY = 3;
  
  react(Stimulations stims) {
    // Get all Blip stimulations.
    var blips = stims.ofType(Blip).toSet();
    // If there are no blips, don't change the state.
    if (blips.length == 0) return;

    // Get data structures (next object id and list of objects) or create them
    // if they don't exist.
    var objects = this.get('', 'objects');
    var nextId = this.get('', 'nextId');
    
    if (objects == null) {
      objects = <ObjectMeta>[];
      nextId = 1;
      this.set('', 'objects', objects);
    }
    
    // Look at all Blip stimulations, trying to map them to existing objects,
    // creating new ones where no good match can be found.
    for (ObjectMeta object in objects) {
      // Increment the inactivity counter for the object.
      object.step();
      
      // We may exhaust blips further down, so test for this case.
      if (blips.length == 0) continue;

      // Find the closest blip.
      // TODO: Don't pick blips with a different radius.
      Vector v = object.getProjectedDelta();
      Blip closest = blips.reduce((a, b) {
        var distA = (v - a.delta).length;
        var distB = (v - b.delta).length;
        return distA < distB ? a : b;
      });

      if ((v - closest.delta).length < MAX_DISTANCE) {
        object.blip = closest;
        // TODO: If another object is projected to be even closer, the blip
        //       should be assigned to that one instead.
        blips.remove(closest);
      }
    }

    // Create objects for unrecognized blips.
    for (Blip blip in blips) {
      objects.add(new ObjectMeta(nextId++, blip));
    }

    // Remove stale objects.
    objects.removeWhere((o) => o.inactivity > MAX_INACTIVITY);
    
    // Create stimulations for all the known objects.
    for (ObjectMeta object in objects) {
      stims.stimulate(new ObjectVisible(object.id, object.getProjectedDelta(), object.velocity, object.blip.radius, object.inactivity));
    }
    
    this.set('', 'nextId', nextId);
  }
}