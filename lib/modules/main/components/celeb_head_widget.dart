import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CelebHead extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const CelebHead({
    Key? key,
    required this.imageWidth,
    required this.imageHeight,
  }) : super(key: key);

  Future<String?> _getImageUrlFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_celeb_image');
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
        return Positioned(
          top: imageHeight * 0.2,
          left: imageWidth * 0.1,
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
  }
}
