import 'package:app/core/network/woocommerce_api_client.dart';
import 'package:app/features/shop/data/models/product_model.dart';
import 'package:app/features/shop/data/models/product_tag_model.dart';
import 'package:app/features/shop/data/models/shop_category_model.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';
import 'package:flutter/foundation.dart';

abstract class ShopRemoteDataSource {
  Future<List<ShopCategoryModel>> getCategories();
  Future<List<ShopCategoryModel>> getParentCategories();
  Future<List<ShopCategoryModel>> getSubCategories(int parentId);
  Future<List<ProductTagEntity>> getProductTags({String? categoryId});
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  Future<ProductModel> getProductById(int productId);
  Future<List<ProductModel>> filterProducts({
    String? query,
    List<int>? categories,
    List<int>? tags,
  });
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final WooCommerceApiClient wooCommerce;

  ShopRemoteDataSourceImpl({required this.wooCommerce});

  @override
  Future<List<ShopCategoryModel>> getCategories() async {
    try {
      final response = await wooCommerce.get('/products/categories');

      if (response is! List) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      final List<dynamic> categoriesData = response;
      return categoriesData
          .map(
            (category) =>
                ShopCategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ShopCategoryModel>> getParentCategories() async {
    try {
      if (kDebugMode) {
        print('🛒 ShopRemoteDataSource: Fetching parent categories...');
      }

      final response = await wooCommerce.get(
        '/products/categories',
        queryParameters: {'parent': 0},
      );

      if (kDebugMode) {
        print('🛒 ShopRemoteDataSource: Response type: ${response.runtimeType}');
        print('🛒 ShopRemoteDataSource: Is List? ${response is List}');
      }

      if (response is! List) {
        if (kDebugMode) {
          print('❌ ShopRemoteDataSource: Invalid response format');
        }
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      if (kDebugMode) {
        print('🛒 ShopRemoteDataSource: Received ${response.length} categories');
      }

      final List<dynamic> categoriesData = response;
      final categories = categoriesData
          .map(
            (category) {
              try {
                return ShopCategoryModel.fromJson(category as Map<String, dynamic>);
              } catch (e) {
                if (kDebugMode) {
                  print('❌ ShopRemoteDataSource: Error parsing category: $e');
                  print('❌ Category data: $category');
                }
                rethrow;
              }
            },
          )
          .toList();

      if (kDebugMode) {
        print('✅ ShopRemoteDataSource: Successfully parsed ${categories.length} categories');
      }

      return categories;
    } catch (e) {
      if (kDebugMode) {
        print('❌ ShopRemoteDataSource: Error in getParentCategories: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ShopCategoryModel>> getSubCategories(int parentId) async {
    try {
      final response = await wooCommerce.get(
        '/products/categories',
        queryParameters: {'parent': parentId},
      );

      if (response is! List) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      final List<dynamic> categoriesData = response;
      return categoriesData
          .map(
            (category) =>
                ShopCategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await wooCommerce.get(
        '/products',
        queryParameters: {
          'category': categoryId.toString(),
          'per_page': 100,
        },
      );

      if (response is! List) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      final List<dynamic> productsData = response;
      return productsData
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    try {
      final response = await wooCommerce.get('/products/$productId');

      if (response is! Map<String, dynamic>) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      return ProductModel.fromJson(response);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> filterProducts({
    String? query,
    List<int>? categories,
    List<int>? tags,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': 100,
      };

      if (query != null && query.isNotEmpty) {
        queryParams['search'] = query;
      }

      if (categories != null && categories.isNotEmpty) {
        queryParams['category'] = categories.join(',');
      }

      if (tags != null && tags.isNotEmpty) {
        queryParams['tag'] = tags.join(',');
      }

      final response = await wooCommerce.get(
        '/products',
        queryParameters: queryParams,
      );

      if (response is! List) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      final List<dynamic> productsData = response;
      return productsData
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductTagEntity>> getProductTags({String? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': 100,
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      final response = await wooCommerce.get(
        '/products/tags',
        queryParameters: queryParams,
      );

      if (response is! List) {
        throw ServerException(
          message: 'Invalid response format',
        );
      }

      final List<dynamic> tagsData = response;
      return tagsData
          .map((tag) => ProductTagModel.fromJson(tag as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
