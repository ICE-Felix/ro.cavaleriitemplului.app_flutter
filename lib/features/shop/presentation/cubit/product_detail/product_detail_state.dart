part of 'product_detail_cubit.dart';

class ProductDetailState extends Equatable {
  final ProductEntity? product;
  final bool isLoading;
  final String? error;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.error,
  });

  ProductDetailState copyWith({
    ProductEntity? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [product, isLoading, error];
}
