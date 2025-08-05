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
    this.productTags = const [],
    this.selectedProductTagsIds = const [],
  });

  final List<ProductEntity> products;
  final int categoryId;
  final bool isLoading;
  final bool isError;
  final String message;
  final List<ProductCategoryEntity> subCategories;
  final List<ProductTagEntity> productTags;
  final List<int> selectedProductTagsIds;
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
    List<ProductTagEntity>? productTags,
    List<int>? selectedProductTagsIds,
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
      productTags: productTags ?? this.productTags,
      selectedProductTagsIds:
          selectedProductTagsIds ?? this.selectedProductTagsIds,
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
    productTags,
    selectedProductTagsIds,
  ];
}
