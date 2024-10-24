import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main_providers/app_state_provider.dart';
import '../services/api/main_api_service.dart';
import '../state/main_state.dart';

class PlayFunctions {
  static Future<void> handleStartButtonPressed(
      BuildContext context, MainModuleApiService moduleApiService) async {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    // Update the app state to "in_play"
    appStateProvider.updateStateData("in_play");

    // Call the separate method to handle loading celeb details
    await _loadCelebDetails(context, appStateProvider, moduleApiService);
  }

  static Future<void> _loadCelebDetails(
      BuildContext context,
      AppStateProvider appStateProvider,
      MainModuleApiService moduleApiService) async {
    try {
      final mainModuleState =
          appStateProvider.getModuleState<MainModuleState>("MainModule");

      if (mainModuleState == null) {
        print("Error: MainModuleState not found");
        return;
      }

      // Update the module state to "play_started"
      mainModuleState.updateModuleState("loading_celeb_details");

      final prefs = await SharedPreferences.getInstance();
      String? selectedCategory = prefs.getString('selectedCategory');

      if (selectedCategory == null) {
        throw Exception('No category selected');
      }

      Map<String, dynamic> celebDetails =
          await moduleApiService.getCelebDetails(selectedCategory);

      String celebName = celebDetails['name'];
      List<String> celebFacts = List<String>.from(celebDetails['facts']);
      String celebImageUrl = celebDetails['image'];

      await prefs.setString('selected_celeb_name', celebName);
      await prefs.setStringList('selected_celeb_facts', celebFacts);
      await prefs.setString('selected_celeb_image', celebImageUrl);

      mainModuleState.updateModuleState("celeb_details_loaded");
    } catch (e) {
      print('Failed to load celebrity details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load celebrity details: $e')),
      );
    }
  }
}
