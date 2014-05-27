part of space;

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