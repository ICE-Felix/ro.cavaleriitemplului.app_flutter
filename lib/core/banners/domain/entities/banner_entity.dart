enum BannerType {
  primary('primary'),
  secondary('secondary');

  const BannerType(this.value);
  final String value;

  static BannerType? getEnumByValue(String value) {
    for (BannerType type in BannerType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}

enum BannerPage {
  shop('shop'),
  venue('venue'),
  service('service');

  const BannerPage(this.value);
  final String value;

  static BannerPage? getEnumByValue(String value) {
    for (BannerPage page in BannerPage.values) {
      if (page.value == value) {
        return page;
      }
    }
    return null;
  }
}

class BannerEntity {
  final String id;
  final String redirectLink;
  final BannerPage page;
  final BannerType type;
  final String imageUrl;

  const BannerEntity({
    required this.id,
    required this.redirectLink,
    required this.page,
    required this.type,
    required this.imageUrl,
  });
}
