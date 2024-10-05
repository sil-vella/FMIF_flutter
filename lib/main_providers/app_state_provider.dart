// lib/main_providers/app_state_provider.dart

import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier {
  String _stateData = "Initial State";

  String get stateData => _stateData;

  void updateStateData(String newData) {
    _stateData = newData;
    notifyListeners(); // Notify listeners to update the UI
  }
}
