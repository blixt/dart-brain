part of brain;

class Stimulations implements Iterable<Stimulation> {
  const int MAX_STIMULATIONS = 1000;
  
  int _counter = 0;
  List<Stimulation> _input = <Stimulation>[];
  List<Stimulation> _output = <Stimulation>[];
  
  Stimulations();
  
  /// Whether there are more stimulations to handle after the current set of
  /// stimulations.
  bool get hasMore => _output.length > 0;
  /// An iterator over the available stimulations.
  Iterator<Stimulation> get iterator => _input.iterator;
  
  /// Gets all the stimulations of the specified type.
  Iterable ofType(Type type) => _input.where((stim) => stim.runtimeType == type);
  
  _iteration() {
    _input.clear();
    var newOutput = _input;

    _input = _output;
    _output = newOutput;
  }
  
  _reset() {
    _counter = 0;
    _iteration();
  }
  
  /// Adds a stimulation to the output.
  bool stimulate(Stimulation stim) {
    print('[stimulations.stimulate] $stim');
    
    if (_counter >= MAX_STIMULATIONS) {
      print('[stimulations.stimulate] IGNORED');
      return false;
    }
    
    _output.add(stim);
    _counter++;
    
    return true;
  }
  
  toString() => 'Stimulations($_input)';
}