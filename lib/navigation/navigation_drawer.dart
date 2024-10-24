import 'package:flutter/material.dart';
import '../modules/base/module_manager.dart'; // Import ModuleRegistry

class CustomNavigationDrawer extends StatelessWidget {
  final ModuleRegistry moduleRegistry;

  const CustomNavigationDrawer({Key? key, required this.moduleRegistry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch navigation items from the registry
    final navigationItems = moduleRegistry.collectNavigationItems();

    return Drawer(
      child: ListView.builder(
        itemCount: navigationItems.length,
        itemBuilder: (context, index) {
          final item = navigationItems[index];
          return ListTile(
            title: Text(item.title),
            onTap: () {
              Navigator.pushNamed(context, item.route);
            },
          );
        },
      ),
    );
  }
}
