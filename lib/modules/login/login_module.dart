import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import '../base/app_module.dart';
import '../base/module_manager.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'services/api/login_api_service.dart';
import '../../services/api/base_api_service.dart';
import 'state/login_state.dart'; // Import the state

class LoginModule extends AppModule {
  final ModuleRegistry moduleRegistry;
  final LoginModuleState loginModuleState; // Add state reference
  final LoginApiService loginApiService;
  final NavigationItemHook navigationHook; // Define the navigation hook

  static const String baseUrl = 'http://192.168.178.80:5000';

  LoginModule(AppStateProvider appStateProvider, this.moduleRegistry)
      : loginModuleState = LoginModuleState(),
        // Initialize state
        loginApiService = LoginApiService(BaseApiService(baseUrl)),
        navigationHook = NavigationItemHook(),
        super(appStateProvider) {
    registerState('LoginModule', loginModuleState);
    _registerNavigationItems(); // Register the navigation items during construction
  }

  @override
  void init() {
    // Update state with initialization message
    appStateProvider.updateStateData("Login Module Initialized");
  }

  @override
  void dispose() {
    // Update state with disposal message
    appStateProvider.updateStateData("Login Module Disposed");
  }

  @override
  Map<String, WidgetBuilder> getRoutes() {
    // Pass loginApiService and state directly to the LoginScreen
    return {
      '/login': (context) => LoginScreen(
            loginApiService: loginApiService,
            appStateProvider: appStateProvider,
            moduleRegistry: moduleRegistry,
          ),
    };
  }

  @override
  NavigationItemHook getNavigationHook() {
    return navigationHook; // Return the defined navigation hook
  }

  void _registerNavigationItems() {
    // Register the navigation items for this module
    navigationHook.register(() {
      return [
        NavigationItem(title: 'Login', route: '/login'),
      ];
    });
  }
}
