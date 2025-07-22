import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';

class GetProductsByCategoryParams {
  final int categoryId;

  GetProductsByCategoryParams({required this.categoryId});
}

class GetProductsByCategoryUseCase
    implements UseCase<List<ProductEntity>, GetProductsByCategoryParams> {
  final ShopRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(GetProductsByCategoryParams params) async {
    return await repository.getProductsByCategory(params.categoryId);
  }
}
