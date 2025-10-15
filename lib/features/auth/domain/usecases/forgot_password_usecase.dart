import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements VoidUseCase<ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  @override
  Future<void> call(ForgotPasswordParams params) async {
    return await repository.resetPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}
