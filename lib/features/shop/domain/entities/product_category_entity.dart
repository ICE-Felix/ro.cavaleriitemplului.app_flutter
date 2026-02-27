import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final int sortOrder;

  const ProductCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    this.sortOrder = 0,
  });

  factory ProductCategoryEntity.fromJson(Map<String, dynamic> json) {
    return ProductCategoryEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      parentId: json['parent_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, imageUrl, parentId, sortOrder];
}
