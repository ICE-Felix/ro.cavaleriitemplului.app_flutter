import 'package:equatable/equatable.dart';
import '../../data/models/support_request_model.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class SubmitSupportRequest extends SupportEvent {
  final String name;
  final String email;
  final String subject;
  final String message;
  final SupportCategory category;

  const SubmitSupportRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.category,
  });

  @override
  List<Object?> get props => [name, email, subject, message, category];
}

class ResetSupportForm extends SupportEvent {
  const ResetSupportForm();
}
