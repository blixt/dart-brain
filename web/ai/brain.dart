part of ai;

class Brain extends Entity {
  final List<Reactor> reactors = <Reactor>[];
  final Stimulations stimulations = new Stimulations();
  
  Brain(position, radius) : super(position, radius);
  
  _step() {
    int i = 1;
    
    while (stimulations.hasMore) {
      stimulations._iteration();
      print('[brain.step] pass #$i');

      for (Reactor r in reactors) {
        print('[reactor.react] $r');
        r.react(stimulations);
      }
      
      i++;
    }
    
    print('[brain.step] done');

    stimulations._reset();
  }
  
  toString() => 'Brain(position=$position, radius=$radius, reactors=$reactors)';
}