import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_core/modules/base/module_manager.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart';
import 'package:flutter_core/utils/consts/theme_consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the module configuration
  ModuleConfig config = await ModuleConfig.loadConfig();
  print('Loaded Module Config: ${config.modules}');

  // Initialize providers and managers
  AppStateProvider appStateProvider = AppStateProvider();
  ModuleRegistry moduleRegistry = ModuleRegistry();
  ModuleManager moduleManager = ModuleManager(appStateProvider);

  // Initialize modules based on the configuration
  moduleManager.initializeModules(config);

  // Print all collected routes for debugging
  final allRoutes = moduleManager.collectAllRoutes();
  print('Collected Routes: $allRoutes');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appStateProvider),
      ],
      child: MyApp(
        moduleRegistry: moduleRegistry,
        moduleManager: moduleManager,
        appStateProvider: appStateProvider,
      ),
    ),
  );
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
    // Collect all routes from the module manager
    final allRoutes = moduleManager.collectAllRoutes();

    // Check if the '/' route exists, and use it as the home if available
    final bool hasHomeRoute = allRoutes.containsKey('/home');

    return MaterialApp(
      theme: AppTheme.darkTheme,
      routes: allRoutes,
      home: hasHomeRoute
          ? null // If '/' exists, let MaterialApp handle it using routes
          : Scaffold(
              appBar: AppBar(title: Text('Home')),
              body: Center(
                child: Text('Welcome to the home screen!'),
              ),
            ),
      initialRoute: hasHomeRoute ? '/home' : null,
    );
  }
}
