import 'package:flutter/material.dart';
import '../services/api/login_api_service.dart';
import '../../../main_providers/app_state_provider.dart';
import '../state/login_state.dart'; // Import LoginModuleState

class LoginWidget extends StatefulWidget {
  final LoginApiService moduleApiService;
  final AppStateProvider appStateProvider;

  const LoginWidget({
    Key? key,
    required this.moduleApiService,
    required this.appStateProvider,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    try {
      setState(() {
        errorMessage = null;
      });

      String username = usernameController.text;
      String password = passwordController.text;

      dynamic response =
          await widget.moduleApiService.login(username, password);

      if (response != null && response['token'] != null) {
        // Retrieve the LoginModuleState from AppStateProvider
        final loginModuleState = widget.appStateProvider
            .getModuleState("LoginModule") as LoginModuleState?;

        if (loginModuleState != null) {
          // Update the login state and save it to SharedPreferences
          loginModuleState.updateLoginState("logged_in");
          await loginModuleState.saveLoginState("logged_in");
        } else {
          print("Error: LoginModuleState not found.");
        }
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Login failed.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Login failed. Please try again.';
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
            'Login',
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
            onPressed: handleLogin,
            child: const Text('Login'),
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
