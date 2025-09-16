class LocationCategoryModel {
  final String id;
  final String name;
  final String? parentId;

  const LocationCategoryModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory LocationCategoryModel.fromJson(Map<String, dynamic> json) {
    return LocationCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'parent_id': parentId};
  }
}
