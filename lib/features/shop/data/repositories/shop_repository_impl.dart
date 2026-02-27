import 'package:app/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductCategoryEntity>> getParentCategories() =>
      remoteDataSource.getParentCategories();

  @override
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId) =>
      remoteDataSource.getSubCategories(parentId);

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) =>
      remoteDataSource.getProductsByCategory(categoryId);

  @override
  Future<ProductEntity> getProductById(String productId) =>
      remoteDataSource.getProductById(productId);

  @override
  Future<List<ProductEntity>> searchProducts(String query) =>
      remoteDataSource.searchProducts(query);
}
