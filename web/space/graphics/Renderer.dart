part of space;

abstract class Renderer {
  final CanvasElement _canvas;
  bool _rendering = false;
  
  CanvasRenderingContext2D get context => _canvas.context2D;
  
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