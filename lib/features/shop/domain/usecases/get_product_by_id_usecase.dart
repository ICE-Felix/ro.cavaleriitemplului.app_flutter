import 'package:app/core/usecases/usecase.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/domain/repositories/shop_repository.dart';

class GetProductByIdParams {
  final int productId;

  GetProductByIdParams({required this.productId});
}

class GetProductByIdUseCase
    implements UseCase<ProductEntity, GetProductByIdParams> {
  final ShopRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<ProductEntity> call(GetProductByIdParams params) async {
    return await repository.getProductById(params.productId);
  }
}
