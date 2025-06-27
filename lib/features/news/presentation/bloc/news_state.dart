part of 'news_bloc.dart';

@immutable
abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;
  final List<String> categories;
  final bool hasMore;
  final String? currentCategory;

  NewsLoaded({
    required this.news,
    this.categories = const [],
    this.hasMore = true,
    this.currentCategory,
  });

  @override
  List<Object?> get props => [news, categories, hasMore, currentCategory];

  NewsLoaded copyWith({
    List<NewsEntity>? news,
    List<String>? categories,
    bool? hasMore,
    String? currentCategory,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
      categories: categories ?? this.categories,
      hasMore: hasMore ?? this.hasMore,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsSearchResults extends NewsState {
  final List<NewsEntity> results;
  final String query;
  final bool hasMore;

  NewsSearchResults({
    required this.results,
    required this.query,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [results, query, hasMore];
}
