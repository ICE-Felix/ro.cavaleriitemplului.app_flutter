import 'package:app/features/shop/data/mock/mock_products.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(SearchProductsState());

  void searchProducts(String query) async {
    if (state.searchQuery == query) {
      return;
    }
    emit(state.copyWith(searchQuery: query));
    if (query.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoading: true));

    // Simulate network delay for realistic behavior
    await Future.delayed(const Duration(milliseconds: 500));

    // Search across all mock products
    final results = MockProducts.searchProducts(query);

    emit(state.copyWith(products: results, isLoading: false));
  }

  void clearSearch() {
    emit(state.copyWith(
      products: [],
      searchQuery: '',
      isLoading: false,
      isError: false,
    ));
  }
}
