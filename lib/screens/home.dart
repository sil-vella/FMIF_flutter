import 'package:flutter/material.dart';
import 'base.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({
    super.key,
    required super.moduleRegistry,
    required super.appStateProvider, // Pass AppStateProvider to BaseScreen
  });

  @override
  Widget buildContent(BuildContext context) {
    return SizedBox.expand(
      // Ensures the container takes up all available space
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home_background_image.jpg'),
            // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
      ),
    );
  }
}
