import 'package:flutter/material.dart';

import '../../screens/home.dart';
import '../../screens/profile.dart';
import '../base/app_module.dart';
import '../base/module_registry.dart';

import 'package:flutter_core/utils/hooks/hook.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';

class ProfileModule extends AppModule {
  final ModuleRegistry moduleRegistry;

  ProfileModule(AppStateProvider appStateProvider, this.moduleRegistry)
      : super(appStateProvider);

  @override
  void init() {
    appStateProvider.updateStateData("Profile Module Initialized");
    // Register navigation items
    registerNavigation(navigationHook);
  }

  @override
  void dispose() {
    appStateProvider.updateStateData("Profile Module Disposed");
  }

  @override
  void registerNavigation(Hook<List<NavigationItem>> navigationHook) {
    navigationHook.register(() {
      var items = [
        NavigationItem(title: 'Profile', route: '/profile'),
      ];
      return items;
    });
  }

  @override
  Map<String, WidgetBuilder> getRoutes() {
    // Pass the ModuleRegistry to HomeScreen
    return {
      '/profile': (context) => ProfileScreen(
          moduleRegistry: moduleRegistry, appStateProvider: appStateProvider),
    };
  }

  @override
  void registerNavigationHook(ModuleRegistry moduleRegistry) {
    // Only register the hook if the module has navigation
    moduleRegistry.registerNavigationHook(navigationHook);
  }
}
