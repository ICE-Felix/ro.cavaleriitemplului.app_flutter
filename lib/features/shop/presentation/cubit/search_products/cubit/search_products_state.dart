part of 'search_products_cubit.dart';

class SearchProductsState extends Equatable {
  const SearchProductsState({
    this.products = const [],
    this.message = '',
    this.isLoading = false,
    this.isError = false,
    this.searchQuery = '',
  });

  final List<ProductEntity> products;
  final String message;
  final bool isLoading;
  final bool isError;
  final String searchQuery;

  SearchProductsState copyWith({
    List<ProductEntity>? products,
    String? message,
    bool? isLoading,
    bool? isError,
    String? searchQuery,
  }) {
    return SearchProductsState(
      products: products ?? this.products,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    products,
    message,
    isLoading,
    isError,
    searchQuery,
  ];
}
