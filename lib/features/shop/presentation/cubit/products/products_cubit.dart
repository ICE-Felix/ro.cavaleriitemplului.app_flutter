import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/error/exceptions.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required int parentCategoryId})
    : super(ProductsState(categoryId: parentCategoryId));

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      final subcategories = await sl.get<ShopRepository>().getSubCategories(
        state.categoryId,
      );
      final productTags = await sl.get<ShopRepository>().getProductTags(
        categoryId: state.categoryId.toString(),
      );
      final categories =
          state.selectedSubCategoriesIds.isEmpty
              ? [state.categoryId]
              : state.selectedSubCategoriesIds;
      final query = state.searchQuery.isEmpty ? null : state.searchQuery;
      final products = await sl.get<ShopRepository>().filterProducts(
        query: query,
        categories: categories,
        tags: state.selectedProductTagsIds,
      );

      emit(
        state.copyWith(
          products: products,
          isLoading: false,
          subCategories: subcategories,
          productTags: productTags,
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

  Future<void> getProducts() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories =
          state.selectedSubCategoriesIds.isEmpty
              ? [state.categoryId]
              : state.selectedSubCategoriesIds;
      final query = state.searchQuery.isEmpty ? null : state.searchQuery;
      final products = await sl.get<ShopRepository>().filterProducts(
        query: query,
        categories: categories,
        tags: state.selectedProductTagsIds,
      );

      emit(state.copyWith(products: products, isLoading: false));
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

  void changeSearchQuery(String? query) {
    if (query == state.searchQuery) {
      return;
    }
    emit(state.copyWith(searchQuery: query));
    getProducts();
  }

  void changeSelectedSubCategoriesIds(List<int>? ids) {
    emit(state.copyWith(selectedSubCategoriesIds: ids ?? []));
    getProducts();
  }

  void changeSelectedProductTagsIds(List<int>? ids) {
    emit(state.copyWith(selectedProductTagsIds: ids ?? []));
    getProducts();
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
