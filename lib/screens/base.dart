import 'package:flutter/material.dart';

import '../modules/base/module_registry.dart';
import '../navigation/navigation_drawer.dart';
import 'package:flutter_core/main_providers/app_state_provider.dart'; // Import AppStateProvider

abstract class BaseScreen extends StatefulWidget {
  final ModuleRegistry moduleRegistry;
  final AppStateProvider appStateProvider; // Add AppStateProvider

  const BaseScreen({
    super.key,
    required this.moduleRegistry,
    required this.appStateProvider, // Require AppStateProvider in constructor
  });

  // Child classes will be forced to implement this to provide their own content
  Widget buildContent(BuildContext context);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Title'), // Common AppBar for all screens
      ),
      drawer: CustomNavigationDrawer(moduleRegistry: widget.moduleRegistry),
      // Common Drawer for all screens
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Child screen's content
          Expanded(
            child: widget.buildContent(
              context,
            ), // The child screen will provide its content here
          ),
        ],
      ),
    );
  }
}
