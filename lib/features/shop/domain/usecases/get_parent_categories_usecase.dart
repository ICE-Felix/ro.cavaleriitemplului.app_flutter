import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';

class GetParentCategoriesUseCase
    implements UseCase<List<ProductCategoryEntity>, NoParams> {
  final ShopRepository repository;

  GetParentCategoriesUseCase(this.repository);
  
  @override
  Future<List<ProductCategoryEntity>> call(NoParams params) async {
    return await repository.getParentCategories();
  }
}