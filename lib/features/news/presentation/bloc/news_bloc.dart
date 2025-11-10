import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/news_entity.dart';
import '../../data/models/category_model.dart';
import '../../data/mock/mock_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  List<NewsEntity> _currentNews = [];
  int _currentPage = 1;
  String? _currentCategoryId;
  List<CategoryModel> _categories = [];

  NewsBloc() : super(NewsInitial()) {
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

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get mock news data
      final allNews = MockNews.getMockNews(category: event.category);

      if (event.refresh || event.page == 1) {
        _currentNews = allNews;
      } else {
        _currentNews.addAll(allNews);
      }

      _currentPage = event.page;

      emit(
        NewsLoaded(
          news: List.from(_currentNews),
          categories: _categories,
          hasMore: false, // No pagination for mock data
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
    emit(
      NewsLoading(
        isRefreshing: false,
        previousState:
            state is NewsLoaded || state is NewsSearchResults ? state : null,
      ),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Search mock news data
      final results = MockNews.searchNews(event.query);

      emit(
        NewsSearchResults(
          results: results,
          query: event.query,
          hasMore: false, // No pagination for mock data
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock categories data
      final now = DateTime.now();
      _categories = [
        CategoryModel(
          id: 'Anunțuri',
          name: 'Anunțuri',
          createdAt: now,
          updatedAt: now,
        ),
        CategoryModel(
          id: 'Istorie',
          name: 'Istorie',
          createdAt: now,
          updatedAt: now,
        ),
        CategoryModel(
          id: 'Simbolistică',
          name: 'Simbolistică',
          createdAt: now,
          updatedAt: now,
        ),
        CategoryModel(
          id: 'Evenimente',
          name: 'Evenimente',
          createdAt: now,
          updatedAt: now,
        ),
        CategoryModel(
          id: 'Filosofie',
          name: 'Filosofie',
          createdAt: now,
          updatedAt: now,
        ),
        CategoryModel(
          id: 'Educație',
          name: 'Educație',
          createdAt: now,
          updatedAt: now,
        ),
      ];

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
