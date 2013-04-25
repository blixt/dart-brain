library ai.approach;

import '../ai.dart';
import '../detection/detection.dart';

class ObjectApproaching extends Stimulation {
  final int objectId;
  final Vector delta;
  final Vector velocity;
  final num approachSpeed;
  
  ObjectApproaching(this.objectId, this.delta, this.velocity, this.approachSpeed);
  
  toString() => 'ObjectApproaching(objectId=$objectId, delta=$delta, velocity=$velocity, approachSpeed=$approachSpeed)';
}

class ApproachReactor extends Reactor {
  react(Stimulations stims) {
    for (ObjectVisible stim in stims.ofType(ObjectVisible)) {
      var dist = stim.delta.length();
  
      var prevDist = this.get(stim.objectId, 'dist');
      this.set(stim.objectId, 'dist', dist);
  
      if (prevDist != null && prevDist > dist) {
        // TODO: Treshold on the approach vector?
        stims.stimulate(new ObjectApproaching(stim.objectId, stim.delta, stim.velocity, prevDist - dist));
      }
    }
  }
}