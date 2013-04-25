import 'dart:html';
import 'dart:math';

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

class UniverseRenderer extends Renderer {
  final Universe universe;
  
  UniverseRenderer(this.universe, CanvasElement canvas) : super(canvas);
  
  _frame(num _) {
    render();
  }
  
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