part of 'news_details_bloc.dart';

sealed class NewsDetailsState extends Equatable {
  const NewsDetailsState();
}

final class NewsDetailsInitial extends NewsDetailsState {
  @override
  List<Object> get props => [];
}

final class NewsDetailsLoading extends NewsDetailsState {
  @override
  List<Object> get props => [];
}

final class NewsDetailsLoaded extends NewsDetailsState {
  final NewsEntity news;

  NewsDetailsLoaded({required this.news});
  @override
  List<Object> get props => [news];
}

final class NewsDetailsError extends NewsDetailsState {
  final String message;
  NewsDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
