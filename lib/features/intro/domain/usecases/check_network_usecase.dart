import '../../../../core/usecases/usecase.dart';
import '../entities/intro_entity.dart';
import '../repositories/intro_repository.dart';

class CheckNetworkUseCase implements UseCase<IntroEntity, NoParams> {
  final IntroRepository repository;

  CheckNetworkUseCase({required this.repository});

  @override
  Future<IntroEntity> call(NoParams params) async {
    return await repository.checkNetworkConnection();
  }
}
