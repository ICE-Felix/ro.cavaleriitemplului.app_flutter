import 'dart:convert';

class LocationModel {
  final String id;
  final String name;
  final String? contactId;
  final String? locationLatitude;
  final String? locationLongitude;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? description;
  final List<String>? attributeIds;
  final String? phoneNo;
  final String? email;
  final bool? isActive;
  final Map<String, dynamic>? businessHours;
  final String? galleryId;
  final List<String>? locationCategoryId;
  final String? orderDisplay;
  final String? imageFeaturedId;

  const LocationModel({
    required this.id,
    required this.name,
    this.contactId,
    this.locationLatitude,
    this.locationLongitude,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.description,
    this.attributeIds,
    this.phoneNo,
    this.email,
    this.isActive,
    this.businessHours,
    this.galleryId,
    this.locationCategoryId,
    this.orderDisplay,
    this.imageFeaturedId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> businessHours = jsonDecode(
      json['business_hours'] ?? '{}',
    );
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contactId: json['contact_id'] as String?,
      locationLatitude: json['location_latitude'] as String?,
      locationLongitude: json['location_longitude'] as String?,
      address: json['address'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
      description: json['description'] as String?,
      attributeIds:
          json['attribute_ids'] != null
              ? List<String>.from(json['attribute_ids'] as List)
              : null,
      phoneNo: json['phone_no'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool?,
      businessHours: businessHours,
      galleryId: json['gallery_id'] as String?,
      locationCategoryId:
          json['venue_category_id'] != null
              ? List<String>.from(json['venue_category_id'] as List)
              : null,
      orderDisplay: json['order_display'] as String?,
      imageFeaturedId: json['image_featured_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_id': contactId,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'description': description,
      'attribute_ids': attributeIds,
      'phone_no': phoneNo,
      'email': email,
      'is_active': isActive,
      'business_hours': businessHours,
      'gallery_id': galleryId,
      'venue_category_id': locationCategoryId,
      'order_display': orderDisplay,
      'image_featured_id': imageFeaturedId,
    };
  }
}
