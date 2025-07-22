import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/shop/domain/usecases/get_product_by_id_usecase.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/core/error/exceptions.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailCubit({required this.getProductByIdUseCase})
    : super(ProductDetailInitial());

  Future<void> loadProductDetail(int productId) async {
    emit(ProductDetailLoading());
    try {
      final product = await getProductByIdUseCase(
        GetProductByIdParams(productId: productId),
      );
      emit(ProductDetailLoaded(product: product));
    } on ServerException catch (e) {
      emit(ProductDetailError(message: e.message));
    } on AuthException catch (e) {
      emit(ProductDetailError(message: e.message));
    } catch (e) {
      emit(ProductDetailError(message: 'An unexpected error occurred: $e'));
    }
  }

  void retry(int productId) {
    loadProductDetail(productId);
  }

  void clearProduct() {
    emit(ProductDetailInitial());
  }

  void setProduct(ProductEntity product) {
    emit(ProductDetailLoaded(product: product));
  }
}
