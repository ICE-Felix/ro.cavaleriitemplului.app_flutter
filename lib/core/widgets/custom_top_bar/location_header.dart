import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../style/app_text_styles.dart';

class LocationHeader extends StatelessWidget {
  final String? locationText;
  final VoidCallback? onLocationTap;

  const LocationHeader({super.key, this.locationText, this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: onLocationTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    locationText ?? 'Location',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
