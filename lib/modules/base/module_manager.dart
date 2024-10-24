import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'package:flutter_core/modules/login/login_module.dart';
import '../../utils/hooks/hook.dart';
import 'app_module.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/modules/main/main_module.dart';

class ModuleManager {
  final AppStateProvider appStateProvider;
  final Map<String, Function()> _moduleConstructors = {};
  final ModuleRegistry moduleRegistry = ModuleRegistry();

  ModuleManager(this.appStateProvider) {
    // Register default module constructors here
    registerDefaultModules();
  }

  void registerDefaultModules() {
    // Register 'MainModule' constructor
    registerModuleConstructor('MainModule', (appStateProvider, moduleRegistry) {
      return MainModule(appStateProvider, moduleRegistry);
    });
    registerModuleConstructor('LoginModule',
        (appStateProvider, moduleRegistry) {
      return LoginModule(appStateProvider, moduleRegistry);
    });

    // Add other default module constructors here if needed
  }

  void registerModuleConstructor(
      String slug, Function(AppStateProvider, ModuleRegistry) constructor) {
    _moduleConstructors[slug] =
        () => constructor(appStateProvider, moduleRegistry);
  }

  void initializeModules(ModuleConfig config) {
    final Set<String> initializedModules = {};

    for (var moduleInfo in config.modules) {
      if (moduleInfo.enabled &&
          moduleInfo.initAtStartup &&
          !initializedModules.contains(moduleInfo.slug)) {
        var module = createModule(moduleInfo.slug);
        if (module != null) {
          module.init();
          moduleRegistry.registerModule(moduleInfo.slug, module);
          module.registerNavigationHook(
              moduleRegistry); // Register navigation hooks here
          initializedModules.add(moduleInfo.slug);
        }
      }
    }
  }

  AppModule? createModule(String slug) {
    final constructor = _moduleConstructors[slug];
    if (constructor != null) {
      return constructor();
    } else {
      print('Warning: Module $slug not found or not registered');
      return null;
    }
  }

  Map<String, WidgetBuilder> collectAllRoutes() {
    Map<String, WidgetBuilder> allRoutes = {};
    for (var module in moduleRegistry.getAllModules()) {
      var moduleRoutes = module.getRoutes();
      // Exclude the '/' route to avoid conflict with `home` property
      moduleRoutes.remove('/');
      allRoutes.addAll(moduleRoutes);
    }
    return allRoutes;
  }

  void disposeAllModules() {
    for (var module in moduleRegistry.getAllModules()) {
      module.dispose();
    }
  }
}

class ModuleRegistry {
  final Map<String, AppModule> _registeredModules = {};
  final List<Hook<List<NavigationItem>>> _navigationHooks = [];

  void registerModule(String slug, AppModule module) {
    _registeredModules[slug] = module;
  }

  void registerNavigationHook(Hook<List<NavigationItem>> hook) {
    if (!_navigationHooks.contains(hook)) {
      _navigationHooks.add(hook);
    }
  }

  List<NavigationItem> collectNavigationItems() {
    List<NavigationItem> allNavigationItems = [];
    for (var hook in _navigationHooks) {
      var items = hook.execute();
      for (var itemList in items) {
        allNavigationItems.addAll(itemList);
      }
    }
    return allNavigationItems;
  }

  List<AppModule> getAllModules() {
    return _registeredModules.values.toList();
  }
}

class ModuleConfig {
  final List<ModuleInfo> modules;

  ModuleConfig({required this.modules});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    var modulesJson = json['modules'] as List;
    List<ModuleInfo> modulesList =
        modulesJson.map((i) => ModuleInfo.fromJson(i)).toList();
    return ModuleConfig(modules: modulesList);
  }

  static Future<ModuleConfig> loadConfig() async {
    String jsonString =
        await rootBundle.loadString('assets/config/modules_config.json');
    Map<String, dynamic> json = jsonDecode(jsonString);
    return ModuleConfig.fromJson(json);
  }
}

class ModuleInfo {
  final String slug;
  final bool enabled;
  final bool initAtStartup;

  ModuleInfo(
      {required this.slug, required this.enabled, required this.initAtStartup});

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      slug: json['slug'],
      enabled: json['enabled'],
      initAtStartup: json['initAtStartup'],
    );
  }
}
