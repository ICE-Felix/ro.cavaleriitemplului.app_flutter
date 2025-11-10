part of 'revista_details_bloc.dart';

@immutable
abstract class RevistaDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RevistaDetailsInitial extends RevistaDetailsState {}

class RevistaDetailsLoading extends RevistaDetailsState {}

class RevistaDetailsLoaded extends RevistaDetailsState {
  final RevistaEntity revista;
  final String? pdfLocalPath;
  final bool isLoadingPdf;
  final String? pdfError;

  RevistaDetailsLoaded({
    required this.revista,
    this.pdfLocalPath,
    this.isLoadingPdf = false,
    this.pdfError,
  });

  @override
  List<Object?> get props => [revista, pdfLocalPath, isLoadingPdf, pdfError];
}

class RevistaDetailsError extends RevistaDetailsState {
  final String message;

  RevistaDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
