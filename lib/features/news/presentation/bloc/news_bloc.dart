import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/news_entity.dart';
import '../../domain/usecases/get_news_usecase.dart';
import '../../domain/usecases/search_news_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../data/models/category_model.dart';
import '../../data/models/pagination_model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  final SearchNewsUseCase searchNewsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  List<NewsEntity> _currentNews = [];
  int _currentPage = 1;
  String? _currentCategoryId;
  List<CategoryModel> _categories = [];

  NewsBloc({
    required this.getNewsUseCase,
    required this.searchNewsUseCase,
    required this.getCategoriesUseCase,
  }) : super(NewsInitial()) {
    on<LoadNewsRequested>(_onLoadNewsRequested);
    on<SearchNewsRequested>(_onSearchNewsRequested);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<LoadMoreNewsRequested>(_onLoadMoreNewsRequested);
  }

  Future<void> _onLoadNewsRequested(
    LoadNewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    if (event.refresh || _currentNews.isEmpty) {
      emit(NewsLoading(isRefreshing: event.refresh));
      _currentNews = [];
      _currentPage = 1;
    }

    try {
      _currentCategoryId = event.category;

      final response = await getNewsUseCase(
        GetNewsParams(page: event.page, category: event.category),
      );

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
      final friendlyMessage = _getFriendlyErrorMessage(e.toString());
      emit(NewsError(friendlyMessage));
    }
  }

  Future<void> _onSearchNewsRequested(
    SearchNewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading(isRefreshing: false));

    try {
      final response = await searchNewsUseCase(
        SearchNewsParams(query: event.query, page: event.page),
      );

      emit(
        NewsSearchResults(
          results: response.news.cast<NewsEntity>(),
          query: event.query,
          hasMore: response.pagination.hasNext,
        ),
      );
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString());
      emit(NewsError(friendlyMessage));
    }
  }

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<NewsState> emit,
  ) async {
    try {
      _categories = await getCategoriesUseCase();

      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(categories: _categories));
      }
    } catch (e) {
      // Categories loading failure shouldn't break the main flow
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
