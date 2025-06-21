import 'package:equatable/equatable.dart';

class IntroEntity extends Equatable {
  final bool isNetworkConnected;
  final bool isIntroCompleted;
  final String? errorMessage;

  const IntroEntity({
    required this.isNetworkConnected,
    required this.isIntroCompleted,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    isNetworkConnected,
    isIntroCompleted,
    errorMessage,
  ];
}
