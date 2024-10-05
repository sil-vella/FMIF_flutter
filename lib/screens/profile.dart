import 'package:flutter/material.dart';
import 'base.dart';

class ProfileScreen extends BaseScreen {
  const ProfileScreen({
    super.key,
    required super.moduleRegistry,
    required super.appStateProvider, // Pass AppStateProvider to BaseScreen
  });

  @override
  Widget buildContent(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              'Welcome to the Profile Screen!',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
