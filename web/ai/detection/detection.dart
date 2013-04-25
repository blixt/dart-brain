library ai.detection;

import '../ai.dart';

class ObjectVisible extends Stimulation {
  final int objectId;
  final Vector delta;
  final num radius;
  final int staleness;

  ObjectVisible(this.objectId, this.delta, this.radius, this.staleness);
  
  toString() => 'ObjectVisible(objectId=$objectId, delta=$delta, radius=$radius, staleness=$staleness)';
}

class ObjectMeta {
  final int id;
  /// The most recent location info of this object.
  Blip _blip;
  /// The delta between the last known delta and the delta before that.
  Vector _deltaDelta = new Vector(0, 0);
  /// The number of steps that the object has not been updated.
  int _inactivity = 0;
  
  // Id is passed in rather than generated because the id should stay local to
  // the code that is using it.
  ObjectMeta(this.id, this._blip);
  
  /// Gets the most recent location info of this object.
  Blip get blip => _blip;
  
  /// Sets the location info of this object.
  set blip(Blip value) {
    _deltaDelta = value.delta - _blip.delta;
    _blip = value;
    _inactivity = 0;
  }
  
  /// The number of steps that the object hasn't been updated.
  int get inactivity => _inactivity;
  
  /// The delta of the object assuming it keeps moving as it did previously.
  Vector getProjectedDelta() => _blip.delta + _deltaDelta * _inactivity;
  
  int step() => ++_inactivity;
  
  toString() => 'ObjectMeta(id=$id, blip=$_blip)';
}

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
        var distA = (v - a.delta).length();
        var distB = (v - b.delta).length();
        return distA < distB ? a : b;
      });

      if ((v - closest.delta).length() < MAX_DISTANCE) {
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
    
    // Create stimulations for all the known objects.
    for (ObjectMeta object in objects) {
      if (object.inactivity > MAX_INACTIVITY) continue;
      stims.stimulate(new ObjectVisible(object.id, object.blip.delta, object.blip.radius, object.inactivity));
    }
    
    this.set('', 'nextId', nextId);
  }
}