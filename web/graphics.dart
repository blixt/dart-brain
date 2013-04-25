import 'dart:html';
import 'dart:math';

import 'ai/ai.dart';
import 'ai/detection/detection.dart';
import 'universe.dart';

abstract class Renderer {
  final CanvasElement _canvas;
  bool _rendering = false;
  
  CanvasRenderingContext2D get context => _canvas.context2d;
  
  Renderer(this._canvas);
  
  _render() {
    if (!_rendering) return;
    render();
    window.requestAnimationFrame((num _) => _render());
  }
  
  render();
  
  start() {
    _rendering = true;
    _render();
  }
  
  stop() {
    _rendering = false;
  }
}

class BrainRenderer extends Renderer {
  final Brain brain;
  final BrainRendererReactor reactor = new BrainRendererReactor();
  
  BrainRenderer(this.brain, CanvasElement canvas) : super(canvas) {
    brain.reactors.add(reactor);
  }

  render() {
    context.fillStyle = '#444';
    context.fillRect(0, 0, 500, 500);
    
    context.strokeStyle = '#f00';
    context.beginPath();
    context.arc(250, 250, 200, 0, PI * 2, false);
    context.stroke();
    context.closePath();

    context.fillStyle = '#ff0';
    context.font = '6pt Arial';

    if (reactor.objects != null) {
      for (var object in reactor.objects) {
        var x = 250 + object.delta.x, y = 250 + object.delta.y;

        var dir = object.velocity.normalized() * (object.radius + 3);

        context.strokeStyle = 'rgba(255, 255, 0, ${1.0 - object.staleness / 3.0})';

        context.beginPath();
        context.arc(x, y, object.radius, 0, PI * 2, false);
        context.moveTo(x, y);
        context.lineTo(x + dir.x, y + dir.y);
        context.stroke();
        context.closePath();

        context.fillText('id: ${object.objectId}', x + object.radius + 3, y + object.radius);
      }
    }
  }
}

class BrainRendererReactor extends Reactor {
  List<ObjectVisible> objects;
  
  BrainRendererReactor();
  
  beforeStep() {
    objects = <ObjectVisible>[];
  }
  
  react(Stimulations stims) {
    objects.addAll(stims.ofType(ObjectVisible));
  }
}

class UniverseRenderer extends Renderer {
  final Universe universe;
  
  UniverseRenderer(this.universe, CanvasElement canvas) : super(canvas);
  
  render() {
    context.fillStyle = '#000';
    context.fillRect(0, 0, 500, 500);
    context.fillStyle = '#0f0';

    for (Entity e in universe) {
      context.beginPath();
      context.arc(e.position.x, e.position.y, e.radius, 0, PI * 2, false);
      context.fill();
      context.closePath();

      if (e.brain != null) {
        context.globalAlpha = .2;
        context.beginPath();
        context.arc(e.position.x, e.position.y, 200, 0, PI * 2, false);
        context.fill();
        context.closePath();
        context.globalAlpha = 1;
      }
    }
  }
}