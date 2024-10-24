class Hook<T> {
  final List<T Function()> _callbacks = [];

  // Register a callback if it hasn't been registered
  void register(T Function() callback) {
    if (!_callbacks.contains(callback)) {
      _callbacks.add(callback);
    } else {
      print("Callback already registered: $callback");
    }
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
