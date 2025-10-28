import 'package:app/core/banners/domain/repositories/banners_repository.dart';
import 'package:app/core/usecases/usecase.dart';

class IncrementBannerClicksUseCase implements VoidUseCase<String> {
  final BannersRepository repository;

  IncrementBannerClicksUseCase({required this.repository});

  @override
  Future<void> call(String bannerId) async {
    await repository.incrementClicks(bannerId);
  }
}
