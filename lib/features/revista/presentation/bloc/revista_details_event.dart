part of 'revista_details_bloc.dart';

@immutable
abstract class RevistaDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRevistaDetailsRequested extends RevistaDetailsEvent {
  final String id;

  LoadRevistaDetailsRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadPdfUrlRequested extends RevistaDetailsEvent {
  final String fileId;

  LoadPdfUrlRequested({required this.fileId});

  @override
  List<Object?> get props => [fileId];
}
