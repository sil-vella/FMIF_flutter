import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/preference_screen.dart';
import '../base/app_module.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'state/main_state.dart';
import 'services/api/main_api_service.dart';
import '../../services/api/base_api_service.dart';
import '../base/module_manager.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart'; // Import the navigation hook

class MainModule extends AppModule {
  final ModuleRegistry moduleRegistry;
  final MainModuleState mainModuleState;
  final MainModuleApiService mainModuleApiService;
  final NavigationItemHook navigationHook; // Define the navigation hook

  static const String baseUrl = 'http://192.168.178.80:5000';

  MainModule(AppStateProvider appStateProvider, this.moduleRegistry)
      : mainModuleState = MainModuleState(),
        mainModuleApiService = MainModuleApiService(BaseApiService(baseUrl)),
        navigationHook = NavigationItemHook(),
        // Initialize the navigation hook
        super(appStateProvider) {
    registerState('MainModule', mainModuleState);
    _registerNavigationItems(); // Register the navigation items during construction
  }

  @override
  void init() {
    if (appStateProvider.getModuleState<MainModuleState>('MainModule') ==
        null) {
      appStateProvider.updateStateData("Main Module Initialized");
    }
  }

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => HomeScreen(
            appStateProvider: appStateProvider,
            mainModuleState: mainModuleState,
            moduleRegistry: moduleRegistry,
            mainModuleApiService: mainModuleApiService,
          ),
      '/home': (context) => HomeScreen(
            appStateProvider: appStateProvider,
            mainModuleState: mainModuleState,
            moduleRegistry: moduleRegistry,
            mainModuleApiService: mainModuleApiService,
          ),
      '/preferences': (context) => PrefScreen(
            appStateProvider: appStateProvider,
            mainModuleState: mainModuleState,
            mainModuleApiService: mainModuleApiService,
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
        NavigationItem(title: 'Home', route: '/home'),
        NavigationItem(title: 'Preferences', route: '/preferences'),
      ];
    });
  }
}
