import 'package:flutter/material.dart';

class LocationsBanner extends StatelessWidget {
  final String imageUrl;
  const LocationsBanner({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 3,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder:
              (context, error, stackTrace) =>
                  Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
