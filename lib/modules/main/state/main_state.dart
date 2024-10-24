import 'package:flutter/material.dart';

class MainModuleState extends ChangeNotifier {
  String _moduleState = "play_stopped";

  // Getter for the module's state
  String get moduleState => _moduleState;

  // Method to update the module's state
  void updateModuleState(String newState) {
    _moduleState = newState;
    notifyListeners(); // Notify listeners of the change
  }
}
