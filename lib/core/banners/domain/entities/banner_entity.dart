enum BannerType { primary, secondary }

enum BannerPage { shop, venue, service }

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
