import 'package:app/core/banners/domain/repositories/banners_repository.dart';
import 'package:app/core/usecases/usecase.dart';

class IncrementBannerDisplaysUseCase implements VoidUseCase<String> {
  final BannersRepository repository;

  IncrementBannerDisplaysUseCase({required this.repository});

  @override
  Future<void> call(String bannerId) async {
    await repository.incrementDisplays(bannerId);
  }
}
