import 'package:flutter/material.dart';

import '../../screens/home.dart';
import '../base/app_module.dart';
import '../base/module_registry.dart';

import 'package:flutter_core/utils/hooks/hook.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart'; // Import AppStateProvider

class MainModule extends AppModule {
  final ModuleRegistry moduleRegistry;

  MainModule(AppStateProvider appStateProvider, this.moduleRegistry)
      : super(appStateProvider);

  @override
  void init() {
    appStateProvider.updateStateData("Main Module Initialized");
    // Register navigation items
    registerNavigation(navigationHook);
  }

  @override
  void dispose() {
    appStateProvider.updateStateData("Main Module Disposed");
  }

  @override
  void registerNavigation(Hook<List<NavigationItem>> navigationHook) {
    navigationHook.register(() {
      var items = [
        NavigationItem(title: 'Home', route: '/home'),
      ];
      return items;
    });
  }

  @override
  Map<String, WidgetBuilder> getRoutes() {
    // Pass the ModuleRegistry to HomeScreen
    return {
      '/': (context) => HomeScreen(
          moduleRegistry: moduleRegistry, appStateProvider: appStateProvider),
      // Root route showing HomeScreen
      '/home': (context) => HomeScreen(
          moduleRegistry: moduleRegistry, appStateProvider: appStateProvider),
    };
  }

  @override
  void registerNavigationHook(ModuleRegistry moduleRegistry) {
    // Only register the hook if the module has navigation
    moduleRegistry.registerNavigationHook(navigationHook);
  }
}
