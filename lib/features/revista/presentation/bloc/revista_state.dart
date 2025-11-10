part of 'revista_bloc.dart';

@immutable
abstract class RevistaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RevistaInitial extends RevistaState {}

class RevistaLoading extends RevistaState {
  final bool isRefreshing;
  final RevistaState? previousState;

  RevistaLoading({this.isRefreshing = false, this.previousState});

  @override
  List<Object?> get props => [isRefreshing, previousState];
}

class RevistaLoaded extends RevistaState {
  final List<RevistaEntity> revistas;
  final bool hasMore;
  final int currentPage;

  RevistaLoaded({
    required this.revistas,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [revistas, hasMore, currentPage];

  RevistaLoaded copyWith({
    List<RevistaEntity>? revistas,
    bool? hasMore,
    int? currentPage,
  }) {
    return RevistaLoaded(
      revistas: revistas ?? this.revistas,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class RevistaError extends RevistaState {
  final String message;

  RevistaError(this.message);

  @override
  List<Object?> get props => [message];
}
