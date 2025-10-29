part of 'search_locations_cubit.dart';

class SearchLocationsState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isError;
  final String? errorMessage;
  final String searchQuery;
  final List<LocationModel> locations;
  final int currentPage;
  final bool hasMorePages;
  final int totalLocations;

  const SearchLocationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isError = false,
    this.errorMessage,
    this.searchQuery = '',
    this.locations = const [],
    this.currentPage = 1,
    this.hasMorePages = true,
    this.totalLocations = 0,
  });

  SearchLocationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isError,
    String? errorMessage,
    String? searchQuery,
    List<LocationModel>? locations,
    int? currentPage,
    bool? hasMorePages,
    int? totalLocations,
  }) {
    return SearchLocationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      locations: locations ?? this.locations,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      totalLocations: totalLocations ?? this.totalLocations,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isError,
    errorMessage,
    searchQuery,
    locations,
    currentPage,
    hasMorePages,
    totalLocations,
  ];
}
