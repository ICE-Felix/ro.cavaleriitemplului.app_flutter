import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/shop/data/models/product_model.dart';
import 'package:app/features/shop/data/models/shop_category_model.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

abstract class ShopRemoteDataSource {
  Future<List<ShopCategoryModel>> getCategories();
  Future<List<ShopCategoryModel>> getParentCategories();
  Future<List<ShopCategoryModel>> getSubCategories(int parentId);
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  Future<ProductModel> getProductById(int productId);
  Future<List<ProductModel>> filterProducts({
    String? query,
    List<int>? categories,
  });
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final SupabaseAuthClient _authClient;

  ShopRemoteDataSourceImpl()
    : _supabaseClient = SupabaseClient(),
      _authClient = SupabaseAuthClient();

  @override
  Future<List<ShopCategoryModel>> getCategories() async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Make API call to fetch categories
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_product_categories',
      );

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch categories: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData =
          responseData['data'] as List<dynamic>;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with category filter
      final queryParams = {'parent': '0'};

      // Make API call to fetch categories
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_product_categories',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch categories: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData =
          responseData['data'] as List<dynamic>;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with category filter
      final queryParams = {'parent': parentId.toString()};

      // Make API call to fetch categories
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_product_categories',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch categories: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData =
          responseData['data'] as List<dynamic>;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with category filter
      // final queryParams = {'category': categoryId.toString()};
      final queryParams = {
        'parent': [categoryId.toString()],
      };

      // Make API call to fetch products with category filter
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch products: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> productsData = responseData['data'] as List<dynamic>;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Make API call to fetch product by ID
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_products/$productId',
      );

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch product: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> productData =
          responseData['data'] as Map<String, dynamic>;
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
  }) async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with category filter
      // final queryParams = {'category': categoryId.toString()};
      final queryParams = {
        if (query != null) 'search': query,
        if (categories != null) 'category': categories.join(','),
      };

      // Make API call to fetch products with category filter
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/woo_products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch products: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> productsData = responseData['data'] as List<dynamic>;
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
}
