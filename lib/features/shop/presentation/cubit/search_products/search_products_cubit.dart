import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(const SearchProductsState());

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      emit(const SearchProductsState());
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await sl<ShopRepository>().searchProducts(query);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
