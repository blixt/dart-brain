import 'dart:html';
import 'dart:math';

import 'ai/ai.dart';
import 'ai/approach/approach.dart';
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
    context.moveTo(250, 250);
    context.lineTo(450, 250);
    context.stroke();
    context.closePath();

    if (!reactor.ready) return;

    context.font = '6pt Arial';

    // Render approaches of objects.
    context.strokeStyle = '#888';
    context.fillStyle = '#888';
    
    for (ObjectApproaching approach in reactor.approaches) {
      context.beginPath();
      context.moveTo(250, 250);
      context.lineTo(250 + approach.delta.x, 250 + approach.delta.y);
      context.stroke();
      context.closePath();
      
      Vector halfway = approach.delta / 2;
      var label = 'distance: ${approach.delta.length.toStringAsFixed(2)} '
                  'approachSpeed: ${approach.approachSpeed.toStringAsFixed(2)}';
      context.fillText(label, 250 + halfway.x, 250 + halfway.y);
    }
    
    // Render objects.
    context.fillStyle = '#ff0';

    for (ObjectVisible object in reactor.objects) {
      var x = 250 + object.delta.x, y = 250 + object.delta.y;

      var dir = object.velocity.normalize() * (object.radius + 3);

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

class BrainRendererReactor extends Reactor {
  bool ready = false;
  List<ObjectApproaching> approaches;
  List<ObjectVisible> objects;
  
  BrainRendererReactor();
  
  beforeStep() {
    approaches = <ObjectApproaching>[];
    objects = <ObjectVisible>[];
    ready = true;
  }
  
  react(Stimulations stims) {
    approaches.addAll(stims.ofType(ObjectApproaching));
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
      
      context.strokeStyle = '#0f0';
      context.beginPath();
      context.moveTo(e.position.x, e.position.y);
      context.lineTo(e.position.x + cos(e.orientation) * (e.radius + 5),
                     e.position.y + sin(e.orientation) * (e.radius + 5));
      context.stroke();
      context.closePath();
      
      var n = e.velocity.normalize();
      var from = e.position + n * e.radius;
      var to = e.position + n * (e.radius + 5);

      context.strokeStyle = '#f00';
      context.beginPath();
      context.moveTo(from.x, from.y);
      context.lineTo(to.x, to.y);
      context.stroke();
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