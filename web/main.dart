import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'ai/ai.dart';
import 'ai/approach/approach.dart';
import 'ai/detection/detection.dart';

import 'universe.dart';
import 'graphics.dart';

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

  u.addEntity(new Entity(new Vector(250, 250), brain: b, radius: 5));

  // Render the universe.
  var ur = new UniverseRenderer(u, query('#universe'));
  ur.start();

  // Render the brain.
  var br = new BrainRenderer(b, query('#brain'));
  br.start();

  // Update the universe.
  new Timer.periodic(const Duration(milliseconds: 50), (Timer _) {
    u.step();
  });
}