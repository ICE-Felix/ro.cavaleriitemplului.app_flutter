part of 'news_bloc.dart';

@immutable
abstract class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNewsRequested extends NewsEvent {
  final String? category;
  final int page;
  final bool refresh;

  LoadNewsRequested({this.category, this.page = 1, this.refresh = false});

  @override
  List<Object?> get props => [category, page, refresh];
}

class SearchNewsRequested extends NewsEvent {
  final String query;
  final int page;

  SearchNewsRequested({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class LoadCategoriesRequested extends NewsEvent {}

class LoadMoreNewsRequested extends NewsEvent {}
