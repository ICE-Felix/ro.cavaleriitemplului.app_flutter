import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';

class LocationAttributesWidget extends StatelessWidget {
  final LocationModel location;

  const LocationAttributesWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    if (location.attributes == null || location.attributes!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group attributes by type
    final groupedAttributes = _groupAttributesByType(location.attributes!);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.getString(label: 'locations.attributes'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          ...groupedAttributes.entries.map((entry) {
            return _AttributeGroup(type: entry.key, attributes: entry.value);
          }),
        ],
      ),
    );
  }

  Map<String, List<LocationAttribute>> _groupAttributesByType(
    List<LocationAttribute> attributes,
  ) {
    final Map<String, List<LocationAttribute>> grouped = {};

    for (final attribute in attributes) {
      if (!grouped.containsKey(attribute.type)) {
        grouped[attribute.type] = [];
      }
      grouped[attribute.type]!.add(attribute);
    }

    return grouped;
  }
}

class _AttributeGroup extends StatelessWidget {
  final String type;
  final List<LocationAttribute> attributes;

  const _AttributeGroup({required this.type, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getTypeDisplayName(context, type),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Attributes list
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                attributes.map((attribute) {
                  return _AttributeChip(attribute: attribute);
                }).toList(),
          ),
        ],
      ),
    );
  }

  String _getTypeDisplayName(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'amenity':
        return context.getString(label: 'locations.amenities');
      case 'size':
        return context.getString(label: 'locations.size');
      case 'accessibility':
        return context.getString(label: 'locations.accessibility');
      case 'features':
        return context.getString(label: 'locations.features');
      case 'services':
        return context.getString(label: 'locations.services');
      default:
        return type.toUpperCase();
    }
  }
}

class _AttributeChip extends StatelessWidget {
  final LocationAttribute attribute;

  const _AttributeChip({required this.attribute});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getAttributeIcon(attribute.value),
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            _formatAttributeValue(attribute.value),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAttributeIcon(String value) {
    final lowerValue = value.toLowerCase();

    // Amenity icons
    if (lowerValue.contains('wifi')) return Icons.wifi;
    if (lowerValue.contains('parking')) return Icons.local_parking;
    if (lowerValue.contains('restaurant') || lowerValue.contains('food'))
      return Icons.restaurant;
    if (lowerValue.contains('bar') || lowerValue.contains('drink'))
      return Icons.local_bar;
    if (lowerValue.contains('gym') || lowerValue.contains('fitness'))
      return Icons.fitness_center;
    if (lowerValue.contains('pool')) return Icons.pool;
    if (lowerValue.contains('spa')) return Icons.spa;
    if (lowerValue.contains('conference') || lowerValue.contains('meeting'))
      return Icons.business;
    if (lowerValue.contains('pet') || lowerValue.contains('dog'))
      return Icons.pets;
    if (lowerValue.contains('smoking')) return Icons.smoking_rooms;
    if (lowerValue.contains('non-smoking')) return Icons.smoke_free;

    // Accessibility icons
    if (lowerValue.contains('wheelchair') || lowerValue.contains('accessible'))
      return Icons.accessible;
    if (lowerValue.contains('elevator')) return Icons.elevator;
    if (lowerValue.contains('ramp')) return Icons.ramp_right;

    // Size icons
    if (lowerValue.contains('small')) return Icons.straighten;
    if (lowerValue.contains('medium')) return Icons.straighten;
    if (lowerValue.contains('large')) return Icons.straighten;

    // Default icon
    return Icons.check_circle_outline;
  }

  String _formatAttributeValue(String value) {
    // Capitalize first letter and replace underscores with spaces
    return value
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }
}
