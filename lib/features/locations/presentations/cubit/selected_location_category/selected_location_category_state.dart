part of 'selected_location_category_cubit.dart';

class SelectedLocationCategoryState extends Equatable {
  const SelectedLocationCategoryState({
    this.isLoading = false,
    this.areLocationsLoading = false,
    this.isError = false,
    this.errorMessage,
    this.locations = const [],
    this.subCategories = const [],
    this.selectedSubcategory,
    this.vectorMapStyle,
    this.attributeFilters = const {},
    this.selectedAttributeIds = const [],
    this.areFiltersLoading = false,
    this.searchQuery = '',
    this.filteredLocations = const [],
  });

  final bool isLoading;
  final bool areLocationsLoading;
  final bool isError;
  final String? errorMessage;
  final List<LocationModel> locations;
  final List<LocationCategoryModel> subCategories;
  final LocationCategoryModel? selectedSubcategory;
  final Style? vectorMapStyle;
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final bool areFiltersLoading;
  final String searchQuery;
  final List<LocationModel> filteredLocations;

  SelectedLocationCategoryState copyWith({
    bool? isLoading,
    bool? areLocationsLoading,
    bool? isError,
    List<LocationModel>? locations,
    List<LocationCategoryModel>? subCategories,
    Nullable<LocationCategoryModel>? selectedSubcategory,
    Nullable<String>? errorMessage,
    Style? vectorMapStyle,
    Map<String, List<AttributeFilterOption>>? attributeFilters,
    List<String>? selectedAttributeIds,
    bool? areFiltersLoading,
    String? searchQuery,
    List<LocationModel>? filteredLocations,
  }) {
    return SelectedLocationCategoryState(
      isLoading: isLoading ?? this.isLoading,
      areLocationsLoading: areLocationsLoading ?? this.areLocationsLoading,
      isError: isError ?? this.isError,
      errorMessage:
          errorMessage != null ? errorMessage.value : this.errorMessage,
      locations: locations ?? this.locations,
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
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    areLocationsLoading,
    isError,
    errorMessage,
    locations,
    subCategories,
    selectedSubcategory,
    vectorMapStyle,
    attributeFilters,
    selectedAttributeIds,
    areFiltersLoading,
    searchQuery,
    filteredLocations,
  ];
}
