part of 'intro_bloc.dart';

@immutable
abstract class IntroEvent extends Equatable {
  const IntroEvent();

  @override
  List<Object> get props => [];
}

class IntroStarted extends IntroEvent {}

class IntroNetworkCheckRequested extends IntroEvent {}

class IntroCompleted extends IntroEvent {}

class IntroAnimationCompleted extends IntroEvent {}
