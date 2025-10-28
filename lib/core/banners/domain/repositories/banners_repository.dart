import 'package:app/core/banners/domain/entities/banner_entity.dart';

abstract class BannersRepository {
  Future<List<BannerEntity>> getBanners();
  Future<void> incrementDisplays(String id);
  Future<void> incrementClicks(String id);
}
