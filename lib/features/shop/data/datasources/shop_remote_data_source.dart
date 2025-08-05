import 'package:app/core/network/dio_client.dart';
import 'package:app/features/shop/data/models/product_model.dart';
import 'package:app/features/shop/data/models/product_tag_model.dart';
import 'package:app/features/shop/data/models/shop_category_model.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';

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
  final DioClient dio;

  ShopRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ShopCategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/woo_product_categories');

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData = response['data'] as List<dynamic>;
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
      final response = await dio.get(
        '/woo_product_categories',
        queryParameters: {'parent': '0'},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData = response['data'] as List<dynamic>;
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
  Future<List<ShopCategoryModel>> getSubCategories(int parentId) async {
    try {
      final response = await dio.get(
        '/woo_product_categories',
        queryParameters: {'parent': parentId.toString()},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData = response['data'] as List<dynamic>;
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
      final response = await dio.get(
        '/woo_products',
        queryParameters: {'category': categoryId.toString()},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> productsData = response['data'] as List<dynamic>;
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
      final response = await dio.get('/woo_products/$productId');

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> productData =
          response['data'] as Map<String, dynamic>;
      return ProductModel.fromJson(productData);
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
      final queryParams = <String, dynamic>{};

      if (query != null && query.isNotEmpty) {
        queryParams['search'] = query;
      }

      if (categories != null && categories.isNotEmpty) {
        queryParams['category'] = categories.join(',');
      }

      if (tags != null && tags.isNotEmpty) {
        queryParams['tag'] = tags.join(',');
      }

      final response = await dio.get(
        '/woo_products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> productsData = response['data'] as List<dynamic>;
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
      final response = await dio.get(
        '/woo_product_tags',
        queryParameters: {if (categoryId != null) 'category': categoryId},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> tagsData = response['data'] as List<dynamic>;
      return tagsData
          .map((tag) => ProductTagModel.fromJson(tag as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
