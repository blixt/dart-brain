import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'ai/ai.dart';
import 'ai/approach/approach.dart';
import 'ai/detection/detection.dart';

class WorldRenderer {
  final CanvasElement canvas;
  final World world;
  
  WorldRenderer(this.world, this.canvas);
  
  _frame(num _) {
    render();
  }
  
  render() {
    CanvasRenderingContext2D context = canvas.context2d;
    
    context.fillStyle = '#000';
    context.fillRect(0, 0, 500, 500);
    context.fillStyle = '#0f0';

    for (Entity e in world) {
      context.beginPath();
      context.arc(e.position.x, e.position.y, e.radius, 0, PI * 2, false);
      context.fill();
      context.closePath();
    }
    
    window.requestAnimationFrame(_frame);
  }
}

main() {
  World w = new World();
  
  var rand = new Random();
  var velocities = new Map<Entity, Vector>();
  for (var i = 0; i < 5; i++) {
    Entity e = new Entity(new Vector(rand.nextDouble() * 500, rand.nextDouble() * 500), 3);
    velocities[e] = new Vector(rand.nextDouble() - 0.5, rand.nextDouble() - 0.5);
    w.addEntity(e);
  }

  WorldRenderer r = new WorldRenderer(w, query('#viewport'));
  r.render();

  Brain b = new Brain(new Vector(250, 250), 5);
  b.reactors.add(new DetectorReactor());
  b.reactors.add(new ApproachReactor());
  w.addEntity(b);

  new Timer.periodic(const Duration(milliseconds: 500), (Timer _) {
    velocities.forEach((e, v) => e.position += v);
    w.step();
  });
}