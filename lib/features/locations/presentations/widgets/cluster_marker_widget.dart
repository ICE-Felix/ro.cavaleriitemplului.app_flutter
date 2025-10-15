import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ClusterMarkerWidget extends StatelessWidget {
  final int count;
  final LatLng point;
  final VoidCallback? onTap;

  const ClusterMarkerWidget({
    super.key,
    required this.count,
    required this.point,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: count > 99 ? 10 : 12,
            ),
          ),
        ),
      ),
    );
  }
}

