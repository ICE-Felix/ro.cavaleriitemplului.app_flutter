import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {
  const SupportInitial();
}

class SupportSubmitting extends SupportState {
  const SupportSubmitting();
}

class SupportSubmitted extends SupportState {
  const SupportSubmitted();
}

class SupportError extends SupportState {
  final String message;

  const SupportError({required this.message});

  @override
  List<Object?> get props => [message];
}
