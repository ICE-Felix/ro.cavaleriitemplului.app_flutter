import 'package:app/features/shop/domain/entities/product_tag_entity.dart';

class ProductTagModel extends ProductTagEntity {
  const ProductTagModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.count,
    required super.termGroup,
  });

  factory ProductTagModel.fromJson(Map<String, dynamic> json) {
    return ProductTagModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      termGroup: json['term_group'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'count': count,
      'term_group': termGroup,
    };
  }

  factory ProductTagModel.fromEntity(ProductTagEntity entity) {
    return ProductTagModel(
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      description: entity.description,
      count: entity.count,
      termGroup: entity.termGroup,
    );
  }

  ProductTagEntity toEntity() {
    return ProductTagEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      count: count,
      termGroup: termGroup,
    );
  }

  ProductTagModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    int? count,
    int? termGroup,
  }) {
    return ProductTagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      count: count ?? this.count,
      termGroup: termGroup ?? this.termGroup,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductTagModel &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.description == description &&
        other.count == count &&
        other.termGroup == termGroup;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        slug.hashCode ^
        description.hashCode ^
        count.hashCode ^
        termGroup.hashCode;
  }

  @override
  String toString() {
    return 'ProductTagModel(id: $id, name: $name, slug: $slug, description: $description, count: $count, termGroup: $termGroup)';
  }
}
