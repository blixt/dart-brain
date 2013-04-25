part of ai;

class Brain {
  final List<Reactor> reactors = <Reactor>[];
  final Stimulations stimulations = new Stimulations();
  
  step() {
    int i = 1;
    
    for (Reactor r in reactors) {
      r.beforeStep();
    }
    
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
  
  toString() => 'Brain(reactors=$reactors)';
}