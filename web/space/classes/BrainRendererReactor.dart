part of space;

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