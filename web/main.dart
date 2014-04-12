library main;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'brain/brain.dart';
import 'space/space.dart';
import 'vector/vector.dart';

main() {
  Brain b = new Brain();
  b.reactors.add(new DetectorReactor());
  b.reactors.add(new ApproachReactor());

  // Set up a universe with some random entities and the brain.
  Universe u = new Universe(new Vector(500, 500));
  
  var rand = new Random();
  for (var i = 0; i < 5; i++) {
    var position = new Vector(rand.nextDouble() * 500, rand.nextDouble() * 500);
    var velocity = new Vector(rand.nextDouble() * 2 - 1, rand.nextDouble() * 2 - 1);
    Entity e = new Entity(position, velocity: velocity);
    u.addEntity(e);
  }

  // The entity that represents the brain.
  var be = new Entity(new Vector(250, 250), brain: b, orientation: PI / 2, radius: 5);
  u.addEntity(be);

  // Render the universe.
  var ur = new UniverseRenderer(u, querySelector('#universe'));
  ur.start();

  // Render the brain.
  var br = new BrainRenderer(b, querySelector('#brain'));
  br.start();

  // Update the universe.
  new Timer.periodic(const Duration(milliseconds: 50), (Timer _) {
    // Constantly rotate the brain entity clockwise.
    be.orientation += 0.01;
    u.step();
  });
}
