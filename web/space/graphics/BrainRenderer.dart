part of space;

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