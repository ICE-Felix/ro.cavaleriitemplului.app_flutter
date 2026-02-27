import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';

abstract class ShopRepository {
  Future<List<ProductCategoryEntity>> getParentCategories();
  Future<List<ProductCategoryEntity>> getSubCategories(String parentId);
  Future<List<ProductEntity>> getProductsByCategory(String categoryId);
  Future<ProductEntity> getProductById(String productId);
  Future<List<ProductEntity>> searchProducts(String query);
}
