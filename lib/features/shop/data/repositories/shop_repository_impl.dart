import 'package:app/features/shop/domain/entities/product_tag_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        print('📦 ShopRepository: Getting parent categories...');
      }

      final categories = await remoteDataSource.getParentCategories();

      if (kDebugMode) {
        print('📦 ShopRepository: Received ${categories.length} categories from datasource');
      }

      final entities = categories.map((category) => category.toEntity()).toList();

      if (kDebugMode) {
        print('✅ ShopRepository: Converted to ${entities.length} entities');
        for (var entity in entities) {
          print('   - ${entity.name} (id: ${entity.id})');
        }
      }

      return entities;
    } on ServerException catch (e) {
      if (kDebugMode) {
        print('❌ ShopRepository: ServerException: ${e.message}');
      }
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('❌ ShopRepository: AuthException: ${e.message}');
      }
      throw AuthException(message: e.message);
    } catch (e) {
      if (kDebugMode) {
        print('❌ ShopRepository: Unexpected error: $e');
      }
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
    List<int>? tags,
  }) async {
    try {
      final products = await remoteDataSource.filterProducts(
        query: query,
        categories: categories,
        tags: tags,
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

  @override
  Future<List<ProductTagEntity>> getProductTags({String? categoryId}) async {
    try {
      final tags = await remoteDataSource.getProductTags(categoryId: categoryId);
      return tags;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }
}
