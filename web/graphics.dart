import 'dart:html';
import 'dart:math';

import 'ai/ai.dart';
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

    context.strokeStyle = '#ff0';
    
    if (reactor.blips != null) {
      for (var blip in reactor.blips) {
        context.beginPath();
        context.arc(250 + blip.delta.x, 250 + blip.delta.y, blip.radius, 0, PI * 2, false);
        context.stroke();
        context.closePath();
      }
    }
  }
}

class BrainRendererReactor extends Reactor {
  List<Blip> blips;
  
  BrainRendererReactor();
  
  react(Stimulations stims) {
    var list = stims.ofType(Blip).toList();
    if (list.length > 0) blips = list;
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
    }
  }
}