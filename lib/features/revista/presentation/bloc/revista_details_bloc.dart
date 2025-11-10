import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/revista_entity.dart';
import '../../domain/repositories/revista_repository.dart';

part 'revista_details_event.dart';
part 'revista_details_state.dart';

class RevistaDetailsBloc extends Bloc<RevistaDetailsEvent, RevistaDetailsState> {
  final RevistaRepository repository;

  RevistaDetailsBloc({required this.repository}) : super(RevistaDetailsInitial()) {
    on<LoadRevistaDetailsRequested>(_onLoadRevistaDetailsRequested);
    on<LoadPdfUrlRequested>(_onLoadPdfUrlRequested);
  }

  Future<void> _onLoadRevistaDetailsRequested(
    LoadRevistaDetailsRequested event,
    Emitter<RevistaDetailsState> emit,
  ) async {
    try {
      emit(RevistaDetailsLoading());

      final revista = await repository.getRevistaById(event.id);

      emit(RevistaDetailsLoaded(revista: revista));
    } catch (e) {
      emit(RevistaDetailsError(e.toString()));
    }
  }

  Future<void> _onLoadPdfUrlRequested(
    LoadPdfUrlRequested event,
    Emitter<RevistaDetailsState> emit,
  ) async {
    if (state is! RevistaDetailsLoaded) return;

    final currentState = state as RevistaDetailsLoaded;

    try {
      emit(RevistaDetailsLoaded(
        revista: currentState.revista,
        isLoadingPdf: true,
      ));

      final pdfPath = await repository.getAuthenticatedPdfUrl(event.fileId);

      emit(RevistaDetailsLoaded(
        revista: currentState.revista,
        pdfLocalPath: pdfPath,
        isLoadingPdf: false,
      ));
    } catch (e) {
      emit(RevistaDetailsLoaded(
        revista: currentState.revista,
        pdfError: e.toString(),
        isLoadingPdf: false,
      ));
    }
  }
}
