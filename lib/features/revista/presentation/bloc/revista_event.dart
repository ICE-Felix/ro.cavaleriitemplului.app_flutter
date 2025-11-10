part of 'revista_bloc.dart';

@immutable
abstract class RevistaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRevistasRequested extends RevistaEvent {
  final int page;
  final bool refresh;

  LoadRevistasRequested({this.page = 1, this.refresh = false});

  @override
  List<Object?> get props => [page, refresh];
}

class LoadMoreRevistasRequested extends RevistaEvent {}
