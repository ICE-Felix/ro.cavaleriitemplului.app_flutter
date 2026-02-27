import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(const ProductDetailState());

  void setProduct(ProductEntity product) {
    emit(state.copyWith(product: product, isLoading: false));
  }
}
