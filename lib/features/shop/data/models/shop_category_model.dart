import 'package:equatable/equatable.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';

class ShopCategoryModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int parent;
  final String description;
  final String display;
  final CategoryImageModel? image;
  final int menuOrder;
  final int count;

  const ShopCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    this.image,
    required this.menuOrder,
    required this.count,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShopCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parent: json['parent'] as int,
      description: json['description'] as String? ?? '',
      display: json['display'] as String? ?? 'default',
      image:
          json['image'] != null
              ? CategoryImageModel.fromJson(
                json['image'] as Map<String, dynamic>,
              )
              : null,
      menuOrder: json['menu_order'] as int,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent': parent,
      'description': description,
      'display': display,
      'image': image?.toJson(),
      'menu_order': menuOrder,
      'count': count,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    parent,
    description,
    display,
    image,
    menuOrder,
    count,
  ];

  /// Convert to ProductCategoryEntity for domain layer
  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      id: id,
      name: name,
      slug: slug,
      parent: parent,
      description: description,
      display: display,
      image: image?.src,
      menuOrder: menuOrder,
      count: count,
    );
  }
}

class CategoryImageModel extends Equatable {
  final int id;
  final String dateCreated;
  final String dateCreatedGmt;
  final String dateModified;
  final String dateModifiedGmt;
  final String src;
  final String name;
  final String alt;

  const CategoryImageModel({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory CategoryImageModel.fromJson(Map<String, dynamic> json) {
    return CategoryImageModel(
      id: json['id'] as int,
      dateCreated: json['date_created'] as String,
      dateCreatedGmt: json['date_created_gmt'] as String,
      dateModified: json['date_modified'] as String,
      dateModifiedGmt: json['date_modified_gmt'] as String,
      src: json['src'] as String,
      name: json['name'] as String,
      alt: json['alt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_created': dateCreated,
      'date_created_gmt': dateCreatedGmt,
      'date_modified': dateModified,
      'date_modified_gmt': dateModifiedGmt,
      'src': src,
      'name': name,
      'alt': alt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    dateCreated,
    dateCreatedGmt,
    dateModified,
    dateModifiedGmt,
    src,
    name,
    alt,
  ];
}
