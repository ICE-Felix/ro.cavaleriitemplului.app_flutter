import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:app/core/error/exceptions.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductCategoryEntity>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return categories.map((category) => category.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductCategoryEntity>> getParentCategories() async {
    try {
      final categories = await remoteDataSource.getParentCategories();
      return categories.map((category) => category.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(int categoryId) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(categoryId);
      return products.map((product) => product.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductCategoryEntity>> getSubCategories(int parentId) async {
    try {
      final categories = await remoteDataSource.getSubCategories(parentId);
      return categories.map((category) => category.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductEntity> getProductById(int productId) async {
    try {
      final product = await remoteDataSource.getProductById(productId);
      return product.toEntity();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductEntity>> filterProducts({
    String? query,
    List<int>? categories,
  }) async {
    try {
      final products = await remoteDataSource.filterProducts(
        query: query,
        categories: categories,
      );
      return products.map((product) => product.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }
}
