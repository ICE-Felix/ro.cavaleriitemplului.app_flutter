import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/localization/app_localization.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: AppColors.error),
              const SizedBox(height: 24),
              Text(
                context.getString(label: 'connectionError'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.onBackground),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(context.getString(label: 'retry')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
