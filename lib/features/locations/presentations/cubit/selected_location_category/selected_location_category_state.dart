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
  });

  final bool isLoading;
  final bool areLocationsLoading;
  final bool isError;
  final String? errorMessage;
  final List<LocationModel> locations;
  final List<LocationCategoryModel> subCategories;
  final LocationCategoryModel? selectedSubcategory;

  SelectedLocationCategoryState copyWith({
    bool? isLoading,
    bool? areLocationsLoading,
    bool? isError,
    List<LocationModel>? locations,
    List<LocationCategoryModel>? subCategories,
    Nullable<LocationCategoryModel>? selectedSubcategory,
    Nullable<String>? errorMessage,
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
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    areLocationsLoading,
    locations,
    subCategories,
    selectedSubcategory,
  ];
}
