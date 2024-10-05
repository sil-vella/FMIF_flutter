import 'package:flutter/material.dart';

import 'module_registry.dart';
import 'module_factory.dart';
import 'module_config.dart';
import 'app_module.dart';

import 'package:flutter_core/utils/hooks/nav_hook.dart'; // Import the centralized navigation hook

class ModuleManager {
  final ModuleRegistry moduleRegistry;
  final ModuleFactory moduleFactory;

  ModuleManager(this.moduleRegistry, this.moduleFactory);

  void initializeModules(ModuleConfig config) {
    final Set<String> initializedModules = {};

    for (var moduleInfo in config.modules) {
      if (moduleInfo.enabled && moduleInfo.initAtStartup && !initializedModules.contains(moduleInfo.slug)) {
        var module = moduleFactory.createModule(moduleInfo.slug);
        print("Initializing module: ${moduleInfo.slug}");
        module.init();

        // Register the module in the registry
        moduleRegistry.registerModule(moduleInfo.slug, module);

        initializedModules.add(moduleInfo.slug); // Mark module as initialized
      }
    }

    // Register the navigation hook with the registry
    moduleRegistry.registerNavigationHook(navigationHook);
  }

  // Method to collect all routes from modules
  Map<String, WidgetBuilder> collectAllRoutes() {
    Map<String, WidgetBuilder> allRoutes = {};
    for (var module in moduleRegistry.getAllModules()) {
      allRoutes.addAll(module.getRoutes());  // Collect routes from each module
    }
    return allRoutes;
  }

  void disposeAllModules() {
    for (var module in moduleRegistry.getAllModules()) {
      module.dispose();
    }
  }
}

