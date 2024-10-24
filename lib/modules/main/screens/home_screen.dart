import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../login/state/login_state.dart';
import '../components/celeb_head_widget.dart';
import '../../../main_providers/app_state_provider.dart';
import '../state/main_state.dart'; // Import MainModuleState
import 'package:flutter_core/modules/base/module_manager.dart'; // Import ModuleRegistry
import 'package:flutter_core/navigation/navigation_drawer.dart';
import '../services/api/main_api_service.dart'; // Import MainModuleApiService
import '../functions/main_functions.dart'; // Import PlayFunctions

class HomeScreen extends StatelessWidget {
  final AppStateProvider appStateProvider;
  final MainModuleState mainModuleState;
  final ModuleRegistry moduleRegistry;
  final MainModuleApiService mainModuleApiService;

  const HomeScreen({
    Key? key,
    required this.appStateProvider,
    required this.mainModuleState,
    required this.moduleRegistry,
    required this.mainModuleApiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModuleState>.value(
      value: mainModuleState,
      child: Consumer<MainModuleState>(
        builder: (context, state, child) {
          final imageWidth = MediaQuery.of(context).size.width;
          final imageHeight = MediaQuery.of(context).size.height;

          // Get the login state directly through AppStateProvider mapping
          final loginModuleState = appStateProvider
              .getModuleState("LoginModule") as LoginModuleState?;
          final loginState = loginModuleState?.loginState ?? "No Login State";

          // Get the general app state from the AppStateProvider
          final appState = appStateProvider.stateData;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Home'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Login State: $loginState",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "App State: $appState",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add the custom navigation drawer
            drawer: CustomNavigationDrawer(moduleRegistry: moduleRegistry),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/app_images/home_background_image.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                CelebHead(
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                ),
                // Add the Start button at the bottom of the screen
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Trigger the handleStartButtonPressed method
                        await PlayFunctions.handleStartButtonPressed(
                          context,
                          mainModuleApiService,
                        );
                      },
                      child: const Text('Start'),
                    ),
                  ),
                ),
                // Display the current state of MainModuleState
                Positioned(
                  top: 10,
                  right: 10,
                  child: Text(
                    "Module State: ${state.moduleState}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
