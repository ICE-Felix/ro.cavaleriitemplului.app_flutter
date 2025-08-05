part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusRequested extends AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthenticationEvent {}

class RegisterRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class GetProfileRequested extends AuthenticationEvent {}

class ForgotPasswordRequested extends AuthenticationEvent {
  final String email;

  ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
