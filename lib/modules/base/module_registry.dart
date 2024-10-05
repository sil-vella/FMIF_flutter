import 'app_module.dart';
import 'package:flutter_core/utils/hooks/hook.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';

class ModuleRegistry {
  final Map<String, AppModule> _registeredModules = {};
  final List<Hook<List<NavigationItem>>> _navigationHooks = [];

  // Register a module
  void registerModule(String slug, AppModule module) {
    _registeredModules[slug] = module;
  }

  // Register a module's navigation hook
  void registerNavigationHook(Hook<List<NavigationItem>> hook) {
    print("Registering navigation hook: $hook");
    _navigationHooks.add(hook);
  }

  // Execute all navigation hooks and collect the results
  List<NavigationItem> collectNavigationItems() {
    print("Collecting navigation items...");
    List<NavigationItem> allNavigationItems = [];
    for (var hook in _navigationHooks) {
      var items = hook.execute();
      print("Executing hook: $hook, Items collected: $items");
      for (var itemList in items) {
        allNavigationItems.addAll(itemList);
      }
    }
    print("All navigation items collected: $allNavigationItems");
    return allNavigationItems;
  }

  // Return all registered modules
  List<AppModule> getAllModules() {
    return _registeredModules.values.toList();
  }
}
