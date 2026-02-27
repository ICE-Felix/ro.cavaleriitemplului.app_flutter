import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

abstract class ShopRemoteDataSource {
  Future<List<ProductCategoryEntity>> getParentCategories();
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId);
  Future<List<ProductEntity>> getProductsByCategory(String categoryId);
  Future<ProductEntity> getProductById(String productId);
  Future<List<ProductEntity>> searchProducts(String query);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ShopRemoteDataSourceImpl() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<List<ProductCategoryEntity>> getParentCategories() async {
    final response = await _client
        .from('shop_categories')
        .select()
        .isFilter('parent_id', null)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductCategoryEntity.fromJson(json))
        .toList();
  }

  @override
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId) async {
    final response = await _client
        .from('shop_categories')
        .select()
        .eq('parent_id', parentId)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductCategoryEntity.fromJson(json))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) async {
    final response = await _client
        .from('shop_products')
        .select()
        .eq('category_id', categoryId)
        .order('sort_order');
    return (response as List)
        .map((json) => ProductEntity.fromJson(json))
        .toList();
  }

  @override
  Future<ProductEntity> getProductById(String productId) async {
    final response = await _client
        .from('shop_products')
        .select()
        .eq('id', productId)
        .single();
    return ProductEntity.fromJson(response);
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final response = await _client
        .from('shop_products')
        .select()
        .ilike('name', '%$query%')
        .order('sort_order');
    return (response as List)
        .map((json) => ProductEntity.fromJson(json))
        .toList();
  }
}
