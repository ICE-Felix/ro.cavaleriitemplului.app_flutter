part of 'venue_products_cubit.dart';

class VenueProductsState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final List<VenueProductModel> products;

  const VenueProductsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.products = const [],
  });

  VenueProductsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<VenueProductModel>? products,
  }) {
    return VenueProductsState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, products];
}
