part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthAuthenticated extends AuthenticationState {
  final UserModel user;

  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthenticationState {}

class AuthError extends AuthenticationState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSent extends AuthenticationState {
  final String message;

  AuthPasswordResetSent({this.message = ''});

  @override
  List<Object?> get props => [message];
}
