part of space;

class ApproachReactor extends Reactor {
  react(Stimulations stims) {
    for (ObjectVisible stim in stims.ofType(ObjectVisible)) {
      var dist = stim.delta.length;
  
      var prevDist = this.get(stim.objectId, 'dist');
      this.set(stim.objectId, 'dist', dist);
  
      if (prevDist != null && prevDist > dist) {
        // TODO: Add "time to collision" to detect collision courses
        // TODO: Use cubic spline interpolation to include acceleration and angular velocity
        stims.stimulate(new ObjectApproaching(stim.objectId, stim.delta, stim.velocity, prevDist - dist));
      }
    }
  }
}