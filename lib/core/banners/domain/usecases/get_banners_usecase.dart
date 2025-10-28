import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/domain/repositories/banners_repository.dart';
import 'package:app/core/usecases/usecase.dart';

class GetBannersUseCase implements NoParamsUseCase<List<BannerEntity>> {
  final BannersRepository repository;

  GetBannersUseCase({required this.repository});

  @override
  Future<List<BannerEntity>> call() async {
    return await repository.getBanners();
  }
}
