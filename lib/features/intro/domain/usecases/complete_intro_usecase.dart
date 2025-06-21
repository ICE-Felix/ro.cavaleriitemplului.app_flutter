import '../../../../core/usecases/usecase.dart';
import '../repositories/intro_repository.dart';

class CompleteIntroUseCase implements UseCase<void, NoParams> {
  final IntroRepository repository;

  CompleteIntroUseCase({required this.repository});

  @override
  Future<void> call(NoParams params) async {
    return await repository.completeIntro();
  }
}
