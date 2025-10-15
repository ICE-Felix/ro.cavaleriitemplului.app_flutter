import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements UseCase<UserModel?, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  @override
  Future<UserModel?> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<void> call(NoParams params) async {
    return await repository.signOut();
  }
}
