import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(SearchProductsState());

  void searchProducts(String query) async {
    emit(state.copyWith(searchQuery: query));
    if (query.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    final results = await sl.get<ShopRemoteDataSource>().filterProducts(query: query);
    emit(state.copyWith(products: results, isLoading: false));
  }

  // void clearSearch() {
  //   emit(SearchProductsInitial());
  // }
}
