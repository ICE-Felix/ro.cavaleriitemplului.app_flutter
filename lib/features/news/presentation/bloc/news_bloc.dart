import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/news_entity.dart';
import '../../data/models/category_model.dart';
import '../../domain/repositories/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  List<NewsEntity> _currentNews = [];
  int _currentPage = 1;
  String? _currentCategoryId;
  List<CategoryModel> _categories = [];
  Timer? _debounceTimer;

  NewsBloc({required this.repository}) : super(NewsInitial()) {
    on<LoadNewsRequested>(_onLoadNewsRequested);
    on<SearchNewsRequested>(_onSearchNewsRequested);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<LoadMoreNewsRequested>(_onLoadMoreNewsRequested);
    on<IncrementNewsReadCount>(_onIncrementNewsReadCount);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadNewsRequested(
    LoadNewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    if (event.refresh || _currentNews.isEmpty) {
      emit(
        NewsLoading(
          isRefreshing: event.refresh,
          previousState:
              state is NewsLoaded || state is NewsSearchResults ? state : null,
        ),
      );
      _currentNews = [];
      _currentPage = 1;
    }

    try {
      _currentCategoryId = event.category;

      final response = event.category != null
          ? await repository.getNewsByCategory(
              event.category!,
              page: event.page,
              limit: 10,
            )
          : await repository.getNews(page: event.page, limit: 10);

      if (event.refresh || event.page == 1) {
        _currentNews = response.news.cast<NewsEntity>();
      } else {
        _currentNews.addAll(response.news.cast<NewsEntity>());
      }

      _currentPage = event.page;

      emit(
        NewsLoaded(
          news: List.from(_currentNews),
          categories: _categories,
          hasMore: response.pagination.hasNext,
          currentCategoryId: _currentCategoryId,
        ),
      );
    } catch (e) {
      if (kDebugMode) print('LoadNews error: $e');
      final friendlyMessage = _getFriendlyErrorMessage(e.toString());
      emit(NewsError(friendlyMessage));
    }
  }

  Future<void> _onSearchNewsRequested(
    SearchNewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    emit(
      NewsLoading(
        isRefreshing: false,
        previousState:
            state is NewsLoaded || state is NewsSearchResults ? state : null,
      ),
    );

    try {
      final response = await repository.searchNews(
        event.query,
        page: event.page,
        limit: 10,
      );

      emit(
        NewsSearchResults(
          results: response.news.cast<NewsEntity>(),
          query: event.query,
          hasMore: response.pagination.hasNext,
        ),
      );
    } catch (e) {
      if (kDebugMode) print('SearchNews error: $e');
      final friendlyMessage = _getFriendlyErrorMessage(e.toString());
      emit(NewsError(friendlyMessage));
    }
  }

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<NewsState> emit,
  ) async {
    try {
      _categories = await repository.getCategories();

      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(categories: _categories));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load categories: $e');
      }
    }
  }

  Future<void> _onLoadMoreNewsRequested(
    LoadMoreNewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasMore) {
        add(
          LoadNewsRequested(
            category: _currentCategoryId,
            page: _currentPage + 1,
          ),
        );
      }
    }
  }

  void _onIncrementNewsReadCount(
    IncrementNewsReadCount event,
    Emitter<NewsState> emit,
  ) {
    final index = _currentNews.indexWhere((n) => n.id == event.newsId);
    if (index != -1) {
      final article = _currentNews[index];
      _currentNews[index] = NewsEntity(
        id: article.id,
        title: article.title,
        content: article.content,
        summary: article.summary,
        imageUrl: article.imageUrl,
        author: article.author,
        publishedAt: article.publishedAt,
        category: article.category,
        source: article.source,
        views: article.views + 1,
        tags: article.tags,
      );

      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(news: List.from(_currentNews)));
      }
    }
  }

  String _getFriendlyErrorMessage(String errorMsg) {
    if (errorMsg.contains('network') || errorMsg.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorMsg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorMsg.contains('not_found')) {
      return 'News not found. Please try again later.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }
}
