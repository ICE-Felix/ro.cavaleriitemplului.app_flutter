import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserModel, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<UserModel> call(RegisterParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
      userData: {'name': params.name},
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
