import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/intro_entity.dart';
import '../../domain/usecases/check_network_usecase.dart';
import '../../domain/usecases/complete_intro_usecase.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final CheckNetworkUseCase checkNetworkUseCase;
  final CompleteIntroUseCase completeIntroUseCase;

  IntroBloc({
    required this.checkNetworkUseCase,
    required this.completeIntroUseCase,
  }) : super(IntroInitial()) {
    on<IntroStarted>(_onIntroStarted);
    on<IntroNetworkCheckRequested>(_onIntroNetworkCheckRequested);
    on<IntroAnimationCompleted>(_onIntroAnimationCompleted);
    on<IntroCompleted>(_onIntroCompleted);
  }

  Future<void> _onIntroStarted(
    IntroStarted event,
    Emitter<IntroState> emit,
  ) async {
    emit(IntroLoading());

    // Add a small delay to show loading state
    await Future.delayed(const Duration(milliseconds: 500));

    // Check network connection
    add(IntroNetworkCheckRequested());
  }

  Future<void> _onIntroNetworkCheckRequested(
    IntroNetworkCheckRequested event,
    Emitter<IntroState> emit,
  ) async {
    try {
      final intro = await checkNetworkUseCase(NoParams());

      if (!intro.isNetworkConnected) {
        emit(IntroNetworkError(intro.errorMessage ?? 'Network error'));
        return;
      }

      // If network is connected, start the animation
      emit(IntroAnimating(isNetworkConnected: intro.isNetworkConnected));

      // Auto-complete animation after 3 seconds
      await Future.delayed(const Duration(seconds: 5));
      add(IntroAnimationCompleted());
    } catch (e) {
      emit(IntroNetworkError('Failed to check network: ${e.toString()}'));
    }
  }

  Future<void> _onIntroAnimationCompleted(
    IntroAnimationCompleted event,
    Emitter<IntroState> emit,
  ) async {
    try {
      await completeIntroUseCase(NoParams());
      emit(IntroNavigateToAuth());
    } catch (e) {
      emit(IntroNetworkError('Failed to complete intro: ${e.toString()}'));
    }
  }

  Future<void> _onIntroCompleted(
    IntroCompleted event,
    Emitter<IntroState> emit,
  ) async {
    emit(IntroNavigateToAuth());
  }
}
