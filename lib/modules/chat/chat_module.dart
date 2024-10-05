import 'package:flutter/material.dart';

import '../../screens/home.dart';
import '../base/app_module.dart';
import '../base/module_registry.dart';
import 'package:flutter_core/utils/hooks/hook.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart'; // Import AppStateProvider

// ChatModule class now accepts AppStateProvider
class ChatModule extends AppModule {
  final ModuleRegistry moduleRegistry;

  ChatModule(AppStateProvider appStateProvider, this.moduleRegistry)
      : super(appStateProvider); // Pass appStateProvider to the base class

  @override
  void init() {
    print("ChatModule initialized");

    // Example of using AppStateProvider to update state
    appStateProvider.updateStateData("Chat Module Initialized");

    // Register navigation items
    registerNavigation(navigationHook);
  }

  @override
  void dispose() {
    print("ChatModule disposed");

    // Example of using AppStateProvider to update state
    appStateProvider.updateStateData("Chat Module Disposed");
  }

  @override
  void registerNavigation(Hook<List<NavigationItem>> navigationHook) {
    navigationHook.register(() {
      var items = [
        NavigationItem(title: 'Chat', route: '/chat'),
      ];
      return items;
    });
  }

  @override
  Map<String, WidgetBuilder> getRoutes() {
    // Pass the ModuleRegistry and AppStateProvider to HomeScreen
    return {
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
