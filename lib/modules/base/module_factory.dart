import 'app_module.dart';
import 'module_registry.dart';
import '../main/main_module.dart';
import '../chat/chat_module.dart';
import '../profiles/profiles_module.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart'; // Import AppStateProvider

class ModuleFactory {
  final ModuleRegistry moduleRegistry;
  final AppStateProvider appStateProvider;

  ModuleFactory(this.moduleRegistry,
      this.appStateProvider); // Accept AppStateProvider in constructor

  /// Creates an instance of a module based on its slug.
  AppModule createModule(String slug) {
    switch (slug) {
      case 'MainModule':
        return MainModule(appStateProvider, moduleRegistry);
      case 'ChatModule':
        return ChatModule(appStateProvider, moduleRegistry);
      case 'ProfileModule':
        return ProfileModule(appStateProvider, moduleRegistry);
      default:
        throw Exception('Module $slug not found');
    }
  }
}
