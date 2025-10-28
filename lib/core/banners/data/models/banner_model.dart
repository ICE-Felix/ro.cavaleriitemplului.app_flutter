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
      page: _parseBannerPage(json['page'] as String),
      type: _parseBannerType(json['type'] as String),
      imageUrl: json['image_url'] as String,
    );
  }

  static BannerPage _parseBannerPage(String page) {
    switch (page.toLowerCase()) {
      case 'shop':
        return BannerPage.shop;
      case 'venue':
        return BannerPage.venue;
      case 'service':
        return BannerPage.service;
      default:
        return BannerPage.shop;
    }
  }

  static BannerType _parseBannerType(String type) {
    switch (type.toLowerCase()) {
      case 'primary':
        return BannerType.primary;
      case 'secondary':
        return BannerType.secondary;
      default:
        return BannerType.secondary;
    }
  }

  static String _bannerPageToString(BannerPage page) {
    switch (page) {
      case BannerPage.shop:
        return 'shop';
      case BannerPage.venue:
        return 'venue';
      case BannerPage.service:
        return 'service';
    }
  }

  static String _bannerTypeToString(BannerType type) {
    switch (type) {
      case BannerType.primary:
        return 'primary';
      case BannerType.secondary:
        return 'secondary';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'redirect_link': redirectLink,
      'page': _bannerPageToString(page),
      'type': _bannerTypeToString(type),
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
