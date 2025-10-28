part of 'selected_location_category_cubit.dart';

class SelectedLocationCategoryState extends Equatable {
  const SelectedLocationCategoryState({
    this.isLoading = false,
    this.areLocationsLoading = false,
    this.isError = false,
    this.errorMessage,
    this.locations = const [],
    this.mapVenues = const [],
    this.subCategories = const [],
    this.selectedSubcategory,
    this.vectorMapStyle,
    this.attributeFilters = const {},
    this.selectedAttributeIds = const [],
    this.areFiltersLoading = false,
    this.searchQuery = '',
    this.filteredLocations = const [],
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
    this.totalLocations = 0,
    this.radiusKm = MapUtils.defaultRadiusKmForList,
  });

  final bool isLoading;
  final bool areLocationsLoading;
  final bool isError;
  final String? errorMessage;
  final List<LocationModel> locations;
  final List<LocationModel> mapVenues;
  final List<LocationCategoryModel> subCategories;
  final LocationCategoryModel? selectedSubcategory;
  final Style? vectorMapStyle;
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final bool areFiltersLoading;
  final String searchQuery;
  final List<LocationModel> filteredLocations;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final int totalLocations;
  final int radiusKm;

  SelectedLocationCategoryState copyWith({
    bool? isLoading,
    bool? areLocationsLoading,
    bool? isError,
    List<LocationModel>? locations,
    List<LocationModel>? mapVenues,
    List<LocationCategoryModel>? subCategories,
    Nullable<LocationCategoryModel>? selectedSubcategory,
    Nullable<String>? errorMessage,
    Style? vectorMapStyle,
    Map<String, List<AttributeFilterOption>>? attributeFilters,
    List<String>? selectedAttributeIds,
    bool? areFiltersLoading,
    String? searchQuery,
    List<LocationModel>? filteredLocations,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    int? totalLocations,
    int? radiusKm,
  }) {
    return SelectedLocationCategoryState(
      isLoading: isLoading ?? this.isLoading,
      areLocationsLoading: areLocationsLoading ?? this.areLocationsLoading,
      isError: isError ?? this.isError,
      errorMessage:
          errorMessage != null ? errorMessage.value : this.errorMessage,
      locations: locations ?? this.locations,
      mapVenues: mapVenues ?? this.mapVenues,
      subCategories: subCategories ?? this.subCategories,
      selectedSubcategory:
          selectedSubcategory != null
              ? selectedSubcategory.value
              : this.selectedSubcategory,
      vectorMapStyle: vectorMapStyle ?? this.vectorMapStyle,
      attributeFilters: attributeFilters ?? this.attributeFilters,
      selectedAttributeIds: selectedAttributeIds ?? this.selectedAttributeIds,
      areFiltersLoading: areFiltersLoading ?? this.areFiltersLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalLocations: totalLocations ?? this.totalLocations,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    areLocationsLoading,
    isError,
    errorMessage,
    locations,
    mapVenues,
    subCategories,
    selectedSubcategory,
    vectorMapStyle,
    attributeFilters,
    selectedAttributeIds,
    areFiltersLoading,
    searchQuery,
    filteredLocations,
    currentPage,
    hasMorePages,
    isLoadingMore,
    totalLocations,
    radiusKm,
  ];
}
