import 'package:flutter/material.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/modules/base/module_manager.dart';

abstract class AppModule {
  final AppStateProvider appStateProvider;

  AppModule(this.appStateProvider);

  // Optional: Called when the module is initialized
  void init() {}

  // Optional: Called when the module is disposed
  void dispose() {}

  // Registers a module's state with the AppStateProvider
  void registerState(String moduleName, ChangeNotifier state) {
    appStateProvider.updateModuleState(moduleName, state);
  }

  // Registers navigation items through a hook
  NavigationItemHook? getNavigationHook() {
    return null; // Override this in specific modules if they have navigation items
  }

  // Registers a module's specific hook into the ModuleRegistry
  void registerNavigationHook(ModuleRegistry moduleRegistry) {
    // Only register the hook if the module has navigation items
    final hook = getNavigationHook();
    if (hook != null) {
      moduleRegistry.registerNavigationHook(hook);
    }
  }

  // Gets routes defined by the module
  Map<String, WidgetBuilder> getRoutes() {
    return {};
  }
}
