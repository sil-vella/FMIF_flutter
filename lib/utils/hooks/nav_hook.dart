// nav_hook.dart or navigation_item_hook.dart
import 'hook.dart'; // Import the base Hook class

class NavigationItem {
  final String title;
  final String route;

  NavigationItem({required this.title, required this.route});
}

class NavigationItemHook extends Hook<List<NavigationItem>> {
  NavigationItemHook();

  // Register a callback with a list of navigation items
  void register(List<NavigationItem> Function() callback) {
    super.register(callback);
  }
}
