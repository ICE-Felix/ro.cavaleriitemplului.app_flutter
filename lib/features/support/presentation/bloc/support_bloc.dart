import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/support_request_model.dart';
import '../../domain/repositories/support_repository.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository repository;

  SupportBloc({required this.repository}) : super(const SupportInitial()) {
    on<SubmitSupportRequest>(_onSubmitSupportRequest);
    on<ResetSupportForm>(_onResetSupportForm);
  }

  Future<void> _onSubmitSupportRequest(
    SubmitSupportRequest event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportSubmitting());

    try {
      final request = SupportRequestModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        email: event.email,
        subject: event.subject,
        message: event.message,
        category: event.category,
        createdAt: DateTime.now(),
      );

      await repository.submitSupportRequest(request);
      emit(const SupportSubmitted());
    } catch (e) {
      emit(SupportError(message: e.toString()));
    }
  }

  Future<void> _onResetSupportForm(
    ResetSupportForm event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportInitial());
  }
}
