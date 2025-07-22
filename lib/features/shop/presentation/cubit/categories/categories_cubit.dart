import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:app/features/shop/domain/usecases/get_parent_categories_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/core/error/exceptions.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await GetParentCategoriesUseCase(
        sl<ShopRepository>(),
      ).call(NoParams());
      print(categories);
      emit(CategoriesLoaded(categories: categories));
    } on ServerException catch (e) {
      print('ServerException: ${e.message}');
      emit(CategoriesError(message: e.message));
    } on AuthException catch (e) {
      print('AuthException: ${e.message}');
      emit(CategoriesError(message: e.message));
    } catch (e) {
      print('Unexpected error: $e');
      emit(CategoriesError(message: 'An unexpected error occurred: $e'));
    }
  }

  void retry() {
    loadCategories();
  }
}
