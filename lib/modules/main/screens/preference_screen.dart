import 'package:flutter/material.dart';
import '../../../main_providers/app_state_provider.dart';
import '../state/main_state.dart';
import '../services/api/main_api_service.dart'; // Import MainModuleApiService
import '../components/categories_widget.dart'; // Import DataDisplayWidget

class PrefScreen extends StatelessWidget {
  final AppStateProvider appStateProvider;
  final MainModuleState mainModuleState;
  final MainModuleApiService mainModuleApiService;

  const PrefScreen({
    super.key,
    required this.appStateProvider,
    required this.mainModuleState,
    required this.mainModuleApiService, // Pass the service instance directly
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'), // Title for the Preferences screen
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Pref Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Add some space between title and widget
            Expanded(
              // Add the DataDisplayWidget here to show fetched data
              child: GetCelebsCategories(
                moduleApiService: mainModuleApiService,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
