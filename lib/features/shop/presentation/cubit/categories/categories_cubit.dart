import 'package:app/core/service_locator.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:app/features/shop/domain/usecases/get_parent_categories_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/usecases/usecase.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  Future<void> loadCategories() async {
    if (kDebugMode) {
      print('🎯 CategoriesCubit: Starting to load categories...');
    }

    emit(CategoriesLoading());

    if (kDebugMode) {
      print('🎯 CategoriesCubit: Emitted CategoriesLoading state');
    }

    try {
      final categories = await GetParentCategoriesUseCase(
        sl<ShopRepository>(),
      ).call(NoParams());

      if (kDebugMode) {
        print('🎯 CategoriesCubit: Received ${categories.length} categories from use case');
        for (var cat in categories) {
          print('   - ${cat.name} (id: ${cat.id})');
        }
      }

      emit(CategoriesLoaded(categories: categories));

      if (kDebugMode) {
        print('✅ CategoriesCubit: Emitted CategoriesLoaded state with ${categories.length} categories');
      }
    } on ServerException catch (e) {
      if (kDebugMode) {
        print('❌ CategoriesCubit: ServerException: ${e.message}');
      }
      emit(CategoriesError(message: e.message));
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('❌ CategoriesCubit: AuthException: ${e.message}');
      }
      emit(CategoriesError(message: e.message));
    } catch (e) {
      if (kDebugMode) {
        print('❌ CategoriesCubit: Unexpected error: $e');
      }
      emit(CategoriesError(message: 'An unexpected error occurred: $e'));
    }
  }

  void retry() {
    if (kDebugMode) {
      print('🔄 CategoriesCubit: Retrying...');
    }
    loadCategories();
  }
}
