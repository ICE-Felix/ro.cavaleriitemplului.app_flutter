part of 'products_cubit.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.subCategories = const [],
    required this.categoryId,
    this.isLoading = false,
    this.isError = false,
    this.message = '',
    this.selectedSubCategoriesIds = const [],
    this.searchQuery = '',
  });

  final List<ProductEntity> products;
  final int categoryId;
  final bool isLoading;
  final bool isError;
  final String message;
  final List<ProductCategoryEntity> subCategories;
  final List<int> selectedSubCategoriesIds;
  final String searchQuery;

  ProductsState copyWith({
    List<ProductEntity>? products,
    int? categoryId,
    bool? isLoading,
    bool? isError,
    String? message,
    List<ProductCategoryEntity>? subCategories,
    List<int>? selectedSubCategoriesIds,
    String? searchQuery,
  }) {
    return ProductsState(
      products: products ?? this.products,
      categoryId: categoryId ?? this.categoryId,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategoriesIds:
          selectedSubCategoriesIds ?? this.selectedSubCategoriesIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    products,
    categoryId,
    isLoading,
    isError,
    message,
    subCategories,
    selectedSubCategoriesIds,
    searchQuery,
  ];
}
