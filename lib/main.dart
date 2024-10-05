import 'package:flutter/material.dart';
import 'package:flutter_core/modules/base/module_config.dart';
import 'package:flutter_core/modules/base/module_registry.dart';
import 'package:flutter_core/modules/base/module_factory.dart';
import 'package:flutter_core/modules/base/module_manager.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'package:flutter_core/utils/consts/theme_consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ModuleConfig config = await ModuleConfig.loadConfig();

  AppStateProvider appStateProvider = AppStateProvider();
  ModuleRegistry moduleRegistry = ModuleRegistry();
  ModuleFactory moduleFactory = ModuleFactory(moduleRegistry, appStateProvider);

  ModuleManager moduleManager = ModuleManager(moduleRegistry, moduleFactory);

  moduleManager.initializeModules(config);

  runApp(MyApp(
    moduleRegistry: moduleRegistry,
    moduleManager: moduleManager,
    appStateProvider: appStateProvider,
  ));
}

class MyApp extends StatelessWidget {
  final ModuleRegistry moduleRegistry;
  final ModuleManager moduleManager;
  final AppStateProvider appStateProvider;

  const MyApp({
    super.key,
    required this.moduleRegistry,
    required this.moduleManager,
    required this.appStateProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: moduleManager.collectAllRoutes(),
    );
  }
}
