import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier {
  // General app state variable to store the main state of the app
  String _stateData = "Initial State";

  // Getter for the general app state variable
  String get stateData => _stateData;

  // Method to update the general app state variable
  void updateStateData(String newData) {
    _stateData = newData;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Map to hold dynamically registered module states
  final Map<String, ChangeNotifier> _moduleStates = {};

  // Add or update a module state in the provider
  void updateModuleState(String moduleName, ChangeNotifier state) {
    _moduleStates[moduleName] = state;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Retrieve a specific module's state by module name
  T? getModuleState<T>(String moduleName) {
    return _moduleStates[moduleName] as T?;
  }

  // Check if a module state is already added
  bool hasModuleState(String moduleName) {
    return _moduleStates.containsKey(moduleName);
  }

  // Remove a module state from the provider if needed
  void removeModuleState(String moduleName) {
    _moduleStates.remove(moduleName);
    notifyListeners(); // Notify listeners to update the UI
  }
}
