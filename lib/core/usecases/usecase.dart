import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class VoidUseCase<Params> {
  Future<void> call(Params params);
}

abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
