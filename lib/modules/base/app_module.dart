import 'package:flutter/material.dart';
import 'package:flutter_core/utils/hooks/hook.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/modules/base/module_registry.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart'; // Import the AppStateProvider

/// AppModule is an abstract class that defines the basic interface for all modules.
/// All modules should extend this class and implement its methods.
abstract class AppModule {
  final AppStateProvider appStateProvider;

  // Constructor to pass the AppStateProvider
  AppModule(this.appStateProvider);

  void init();

  void dispose();

  void registerNavigation(Hook<List<NavigationItem>> navigationHook);

  // New method to optionally register navigation hooks
  void registerNavigationHook(ModuleRegistry moduleRegistry) {
    // Default behavior: do nothing, this is for modules without navigation
  }

  Map<String, WidgetBuilder> getRoutes();
}
