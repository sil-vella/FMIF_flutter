import 'package:flutter/material.dart';
import '../components/login_widget.dart';
import '../components/register_widget.dart';
import '../../../main_providers/app_state_provider.dart';
import 'package:flutter_core/modules/base/module_manager.dart';
import '../services/api/login_api_service.dart'; // Import LoginApiService

class LoginScreen extends StatefulWidget {
  final ModuleRegistry moduleRegistry;
  final AppStateProvider appStateProvider;
  final LoginApiService loginApiService; // Pass the LoginApiService directly

  const LoginScreen({
    Key? key,
    required this.moduleRegistry,
    required this.appStateProvider,
    required this.loginApiService, // Require loginApiService in constructor
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true; // Flag to toggle between login and register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Toggle between LoginWidget and RegisterWidget based on `showLogin`
          Expanded(
            child: showLogin
                ? LoginWidget(
                    moduleApiService: widget.loginApiService,
                    // Use the service directly
                    appStateProvider: widget.appStateProvider,
                  )
                : RegisterWidget(
                    moduleApiService: widget.loginApiService,
                    // Use the service directly
                    appStateProvider: widget.appStateProvider,
                  ),
          ),
          const SizedBox(height: 16),
          // Button to switch between login and register
          TextButton(
            onPressed: () {
              setState(() {
                showLogin = !showLogin; // Toggle the flag to switch widgets
              });
            },
            child: Text(
              showLogin
                  ? 'Don\'t have an account? Register'
                  : 'Already have an account? Login',
            ),
          ),
        ],
      ),
    );
  }
}
