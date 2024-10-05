// Hook class definition
class Hook<T> {
  final List<T Function()> _callbacks = [];

  // Register a callback
  void register(T Function() callback) {
    _callbacks.add(callback);
  }

  // Execute all registered callbacks and return a list of results
  List<T> execute() {
    final results = <T>[];
    for (var callback in _callbacks) {
      results.add(callback());
    }
    return results;
  }

  // Clear all registered callbacks
  void clear() {
    _callbacks.clear();
  }
}