import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/revista_entity.dart';
import '../../domain/repositories/revista_repository.dart';

part 'revista_event.dart';
part 'revista_state.dart';

class RevistaBloc extends Bloc<RevistaEvent, RevistaState> {
  final RevistaRepository repository;

  RevistaBloc({required this.repository}) : super(RevistaInitial()) {
    on<LoadRevistasRequested>(_onLoadRevistasRequested);
    on<LoadMoreRevistasRequested>(_onLoadMoreRevistasRequested);
  }

  Future<void> _onLoadRevistasRequested(
    LoadRevistasRequested event,
    Emitter<RevistaState> emit,
  ) async {
    try {
      // If refreshing, keep previous state visible
      if (event.refresh && state is RevistaLoaded) {
        emit(RevistaLoading(isRefreshing: true, previousState: state));
      } else {
        emit(RevistaLoading());
      }

      final revistas = await repository.getRevistas(
        page: event.page,
        limit: 10,
      );

      emit(RevistaLoaded(
        revistas: revistas,
        hasMore: revistas.length >= 10,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(RevistaError(e.toString()));
    }
  }

  Future<void> _onLoadMoreRevistasRequested(
    LoadMoreRevistasRequested event,
    Emitter<RevistaState> emit,
  ) async {
    if (state is! RevistaLoaded) return;

    final currentState = state as RevistaLoaded;
    if (!currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final moreRevistas = await repository.getRevistas(
        page: nextPage,
        limit: 10,
      );

      emit(currentState.copyWith(
        revistas: [...currentState.revistas, ...moreRevistas],
        hasMore: moreRevistas.length >= 10,
        currentPage: nextPage,
      ));
    } catch (e) {
      // Keep current state on error
      emit(RevistaError(e.toString()));
    }
  }
}
