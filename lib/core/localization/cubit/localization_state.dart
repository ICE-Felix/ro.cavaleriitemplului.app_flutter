import 'package:equatable/equatable.dart';

abstract class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object> get props => [];
}

class LocalizationInitial extends LocalizationState {}

class LocalizationLoading extends LocalizationState {}

class LocalizationLoaded extends LocalizationState {
  final Map<String, dynamic> strings;
  final String currentLocale;

  const LocalizationLoaded({
    required this.strings,
    required this.currentLocale,
  });

  @override
  List<Object> get props => [strings, currentLocale];
}

class LocalizationError extends LocalizationState {
  final String message;

  const LocalizationError({required this.message});

  @override
  List<Object> get props => [message];
}
