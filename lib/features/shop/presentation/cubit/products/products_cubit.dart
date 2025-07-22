import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/error/exceptions.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsState(categoryId: 0));

  Future<void> getProducts(int parentCategoryId, {String? searchQuery, List<int>? selectedSubCategoriesIds}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final subcategories = await sl.get<ShopRepository>().getSubCategories(
        parentCategoryId,
      );
      final categories = selectedSubCategoriesIds == null || selectedSubCategoriesIds.isEmpty
          ? [parentCategoryId]
          : selectedSubCategoriesIds;
      final query = searchQuery == null || searchQuery.isEmpty ? null : searchQuery;
      final products = await sl.get<ShopRepository>().filterProducts(
        query: query,
        categories: categories,
      );

      emit(
        state.copyWith(
          products: products,
          isLoading: false,
          subCategories: subcategories,
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(isError: true, message: e.message));
    } on AuthException catch (e) {
      emit(state.copyWith(isError: true, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'An unexpected error occurred: $e',
        ),
      );
    }
  }

  void retry(int categoryId) {
    getProducts(categoryId);
  }

  void clearProducts() {
    emit(
      state.copyWith(
        products: [],
        isLoading: false,
        isError: false,
        message: '',
      ),
    );
  }
}
