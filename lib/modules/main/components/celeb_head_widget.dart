import 'package:flutter/material.dart';
import 'dart:math'; // For the rotation (pi)
import 'package:shared_preferences/shared_preferences.dart';

class CelebHead extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;

  const CelebHead({
    Key? key,
    required this.imageWidth,
    required this.imageHeight,
  }) : super(key: key);

  @override
  _CelebHeadState createState() => _CelebHeadState();
}

class _CelebHeadState extends State<CelebHead>
    with SingleTickerProviderStateMixin {
  final GlobalKey _overlayKey =
      GlobalKey(); // Key to get the position and size of the overlay background
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double? _overlayHeight; // To store the height of the overlay background
  double? _overlayWidth; // To store the width of the overlay background
  double celebHeadHeight = 100.0; // Fixed height of the CelebHead image
  double celebHeadWidth =
      100.0; // Fixed width of the CelebHead image (will be dynamically calculated)

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getImageUrlFromPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final imageUrl = snapshot.data;

        // Trigger animation on build
        _animationController.reset();
        _animationController.forward();

        // If we have the overlay's width, calculate the width/height of the celeb head
        if (_overlayWidth != null) {
          celebHeadWidth = _overlayWidth! * 0.1; // 10% of the overlay width
          celebHeadHeight =
              celebHeadWidth; // Keep aspect ratio 1:1 for width and height
        }

        // Define the slide animation (50% downward)
        _slideAnimation = Tween<double>(
          begin: 0.0, // Starting position (top)
          end: celebHeadHeight *
              0.4, // Move downward by 50% of the celeb head height
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));

        return Stack(
          children: [
            // CelebHead image placed behind the overlay
            if (_overlayHeight != null)
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Positioned(
                    // Initial top position at 65% of the overlay height, adjusted by animation
                    top: (_overlayHeight! * 0.65) -
                        celebHeadHeight +
                        _slideAnimation.value,
                    left: (widget.imageWidth / 2) - (celebHeadWidth / 2),
                    // Center horizontally
                    child: Transform.rotate(
                      angle: pi, // Rotate the image 180 degrees (pi radians)
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: celebHeadWidth,
                              // Dynamic width based on overlay width
                              height: celebHeadHeight,
                              // Maintain aspect ratio
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 50,
                                  color: Colors.red,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                // Show loading indicator while the image is loading
                                if (loadingProgress == null) {
                                  return child; // Return the fully loaded image
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                    ),
                  );
                },
              ),
            // Full background image overlay on top of the celeb head
            Positioned.fill(
              key: _overlayKey, // Assign GlobalKey to the overlay image
              child: Image.asset(
                'assets/app_images/home_background_image_overlay2.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _getImageUrlFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_celeb_image');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // After the first frame is rendered, calculate the height and width of the overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOverlayDimensions();
    });
  }

  // Method to get the dimensions of the overlay background
  void _getOverlayDimensions() {
    final RenderBox? overlayBox =
        _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlayBox != null) {
      setState(() {
        _overlayHeight =
            overlayBox.size.height; // Get the height of the overlay background
        _overlayWidth =
            overlayBox.size.width; // Get the width of the overlay background
      });
    }
  }
}
