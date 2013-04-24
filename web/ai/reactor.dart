part of ai;

abstract class Reactor {
  final Map<dynamic, Map<String, dynamic>> memory = new Map<dynamic, Map<String, dynamic>>();
  
  get(context, key) {
    var value = memory[context];
    if (value == null) return null;
    return memory[context][key];
  }
  
  List<Stimulation> react(Stimulations stims);
  
  set(context, key, value) {
    var store = memory[context];
    if (store == null) {
      memory[context] = store = <String, dynamic>{}; 
    }
    store[key] = value;
  }
}