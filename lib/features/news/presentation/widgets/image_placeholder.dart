import 'package:flutter/material.dart';

import '../../../../core/style/app_text_styles.dart';

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4A148C), // Dark purple
            const Color(0xFF6A1B9A), // Slightly lighter purple
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo/logo.png',
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if logo asset fails to load
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'MOMMY HAI',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
