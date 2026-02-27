import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final String categoryId;

  ProductsCubit({required this.categoryId}) : super(const ProductsState());

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await sl<ShopRepository>().getProductsByCategory(categoryId);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
