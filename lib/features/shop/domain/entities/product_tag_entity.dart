class ProductTagEntity {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int count;
  final int termGroup;

  const ProductTagEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.count,
    required this.termGroup,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductTagEntity &&
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
    return 'ProductTagEntity(id: $id, name: $name, slug: $slug, description: $description, count: $count, termGroup: $termGroup)';
  }
}
