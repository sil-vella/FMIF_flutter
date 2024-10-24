import 'package:flutter/material.dart';
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
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for the slide animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the animation to slide the image from top to center
    _slideAnimation =
        Tween<double>(begin: -100, end: widget.imageHeight * 0.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<String?> _getImageUrlFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_celeb_image');
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

        // Always trigger the animation when the widget is rebuilt
        if (imageUrl != null && imageUrl.isNotEmpty) {
          _animationController.reset(); // Reset the animation controller
          _animationController.forward(); // Start the animation on rebuild
        }

        return AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Positioned(
              top: _slideAnimation.value, // Use animated value for sliding
              left: widget.imageWidth * 0.1,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.red,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
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
            );
          },
        );
      },
    );
  }
}
