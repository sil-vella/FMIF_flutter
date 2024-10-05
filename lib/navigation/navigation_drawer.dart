import 'package:flutter/material.dart';
import 'package:flutter_core/utils/hooks/nav_hook.dart';
import 'package:flutter_core/modules/base/module_registry.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final ModuleRegistry moduleRegistry;

  const CustomNavigationDrawer({super.key, required this.moduleRegistry});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // This mimics the look of an AppBar at the top of the drawer
          AppBar(
            title: const Text('Navigation'),
            automaticallyImplyLeading:
                false, // This hides the back button in the drawer's AppBar
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: buildDrawerItems(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildDrawerItems(BuildContext context) {
    List<NavigationItem> allNavigationItems =
        moduleRegistry.collectNavigationItems();
    print("Building drawer items: $allNavigationItems");

    return allNavigationItems.map((item) {
      print("Creating ListTile for: ${item.title}, Route: ${item.route}");
      return ListTile(
        title: Text(item.title),
        onTap: () {
          print("Navigating to: ${item.route}");
          Navigator.of(context).pushNamed(item.route);
        },
      );
    }).toList();
  }
}
