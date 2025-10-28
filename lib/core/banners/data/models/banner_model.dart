import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.redirectLink,
    required super.page,
    required super.type,
    required super.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      redirectLink: json['redirect_link'] as String,
      page: BannerPage.getEnumByValue(json['page'] as String)!,
      type: BannerType.getEnumByValue(json['type'] as String)!,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'redirect_link': redirectLink,
      'page': page.value,
      'type': type.value,
      'image_url': imageUrl,
    };
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      redirectLink: redirectLink,
      page: page,
      type: type,
      imageUrl: imageUrl,
    );
  }
}
