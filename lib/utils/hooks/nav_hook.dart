import 'hook.dart';

// NavigationItem class definition
class NavigationItem {
  final String title;
  final String route;

  NavigationItem({required this.title, required this.route});
}

// Global instance of Hook for NavigationItem
final navigationHook = Hook<List<NavigationItem>>();
