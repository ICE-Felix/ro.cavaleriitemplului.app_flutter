import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';

abstract class ShopRepository {
  Future<List<ProductCategoryEntity>> getCategories();
  Future<List<ProductEntity>> getProductsByCategory(int categoryId);
  Future<ProductEntity> getProductById(int productId);
  Future<List<ProductCategoryEntity>> getParentCategories();
  Future<List<ProductCategoryEntity>> getSubCategories(int parentId);
  Future<List<ProductTagEntity>> getProductTags({String? categoryId});
  Future<List<ProductEntity>> filterProducts({
    String? query,
    List<int>? categories,
    List<int>? tags,
  });
}
