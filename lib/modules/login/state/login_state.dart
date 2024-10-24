import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModuleState extends ChangeNotifier {
  // The state that this module will manage (e.g., login states like "logged_out", "logged_in", "registered")
  String _loginState = "logged_out";

  // Getter for the module's state
  String get loginState => _loginState;

  // Method to update the module's state
  void updateLoginState(String newState) {
    _loginState = newState;
    notifyListeners(); // Notify listeners of the change
  }

  // Method to listen for SharedPreferences changes for stored login status or tokens
  Future<void> listenForLoginStateChange() async {
    final prefs = await SharedPreferences.getInstance();
    String? newLoginState = prefs.getString('login_state');

    // Notify listeners if there are changes in SharedPreferences
    if (newLoginState != null && newLoginState != _loginState) {
      _loginState = newLoginState;
      notifyListeners();
    }
  }

  // Method to store the login state in SharedPreferences
  Future<void> saveLoginState(String newState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_state', newState);
    updateLoginState(newState); // Update the local state
  }

  // Method to retrieve the stored login state from SharedPreferences
  Future<String> getStoredLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_state') ?? "logged_out";
  }
}
