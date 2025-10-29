import 'package:app/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

class LocationsButtonSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final EdgeInsets? margin;
  final double? height;

  const LocationsButtonSearchBar({
    super.key,
    required this.onTap,
    this.margin,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      height: height ?? 50.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.search, color: Colors.grey, size: 24.0),
              ),
              Expanded(
                child: Text(
                  context.getString(label: 'locations.searchLocations'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
