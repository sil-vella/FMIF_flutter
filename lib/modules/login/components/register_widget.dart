import 'package:flutter/material.dart';
import '../services/api/login_api_service.dart';
import '../../../main_providers/app_state_provider.dart';
import '../state/login_state.dart'; // Import LoginModuleState

class RegisterWidget extends StatefulWidget {
  final LoginApiService moduleApiService;
  final AppStateProvider appStateProvider;

  const RegisterWidget({
    Key? key,
    required this.moduleApiService,
    required this.appStateProvider,
  }) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    try {
      setState(() {
        errorMessage = null;
      });

      String username = usernameController.text;
      String password = passwordController.text;

      dynamic response =
          await widget.moduleApiService.register(username, password);

      if (response != null && response['success'] == true) {
        // Retrieve the LoginModuleState from AppStateProvider
        final loginModuleState = widget.appStateProvider
            .getModuleState("LoginModule") as LoginModuleState?;

        if (loginModuleState != null) {
          // Update the login state and save it to SharedPreferences
          loginModuleState.updateLoginState("registered");
          await loginModuleState.saveLoginState("registered");
        } else {
          print("Error: LoginModuleState not found.");
        }
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Registration failed.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Registration failed. Please try again.';
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Register',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: handleRegister,
            child: const Text('Register'),
          ),
          if (errorMessage != null)
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
