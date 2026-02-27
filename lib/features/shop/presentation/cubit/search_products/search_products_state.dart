part of 'search_products_cubit.dart';

class SearchProductsState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;

  const SearchProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  SearchProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
  }) {
    return SearchProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, error];
}
