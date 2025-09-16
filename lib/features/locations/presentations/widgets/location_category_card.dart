import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:flutter/material.dart';

class LocationCategoryCard extends StatelessWidget {
  final LocationCategoryModel location;
  final VoidCallback? onTap;

  const LocationCategoryCard({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              location.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
