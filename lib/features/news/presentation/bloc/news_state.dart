part of 'news_bloc.dart';

@immutable
abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final bool isRefreshing;
  final NewsState? previousState;

  NewsLoading({this.isRefreshing = false, this.previousState});

  @override
  List<Object?> get props => [isRefreshing, previousState];
}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;
  final List<CategoryModel> categories;
  final bool hasMore;
  final String? currentCategoryId;

  NewsLoaded({
    required this.news,
    this.categories = const [],
    this.hasMore = true,
    this.currentCategoryId,
  });

  @override
  List<Object?> get props => [news, categories, hasMore, currentCategoryId];

  NewsLoaded copyWith({
    List<NewsEntity>? news,
    List<CategoryModel>? categories,
    bool? hasMore,
    String? currentCategoryId,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
      categories: categories ?? this.categories,
      hasMore: hasMore ?? this.hasMore,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
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
