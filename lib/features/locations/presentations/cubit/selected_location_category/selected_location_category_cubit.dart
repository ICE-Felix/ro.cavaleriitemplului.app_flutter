import 'package:app/core/service_locator.dart';
import 'package:app/core/utils/nullable.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

part 'selected_location_category_state.dart';

class SelectedLocationCategoryCubit
    extends Cubit<SelectedLocationCategoryState> {
  SelectedLocationCategoryCubit({required this.parentCategoryId})
    : super(SelectedLocationCategoryState());
  final LocationsRepository _repository = sl<LocationsRepository>();
  final String parentCategoryId;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      LocationCategoryModel? selectedSubcategory;
      final subcategories = await _repository.getAllSubCategories(
        parentCategoryId,
      );
      List<LocationModel> locations = [];
      if (subcategories.isNotEmpty) {
        locations = await _repository.getAllLoactionsForCategory(
          subcategories.first.id,
        );
        selectedSubcategory = subcategories.first;
      }
      final vectorMapStyle =
          await StyleReader(
            uri: 'https://tiles.openfreemap.org/styles/bright',
          ).read();
      emit(
        state.copyWith(
          isLoading: false,
          locations: locations,
          filteredLocations: locations,
          subCategories: subcategories,
          selectedSubcategory: Nullable(value: selectedSubcategory),
          vectorMapStyle: vectorMapStyle,
        ),
      );
    } catch (e,str) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  Future<void> selectSubcategory(LocationCategoryModel? subcategory) async {
    emit(state.copyWith(areLocationsLoading: true));
    try {
      final locations = await _repository.getAllLoactionsForCategory(
        subcategory?.id,
      );
      emit(
        state.copyWith(
          isLoading: false,
          areLocationsLoading: false,
          locations: locations,
          filteredLocations: _filterLocations(locations, state.searchQuery),
          selectedSubcategory: Nullable(value: subcategory),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          areLocationsLoading: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  Future<void> loadAttributeFilters() async {
    emit(state.copyWith(areFiltersLoading: true));
    try {
      final attributeFilters = await _repository.getVenueAttributeFilters();
      emit(
        state.copyWith(
          areFiltersLoading: false,
          attributeFilters: attributeFilters,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          areFiltersLoading: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  Future<void> applyAttributeFilters(List<String> attributeIds) async {
    emit(state.copyWith(areLocationsLoading: true));
    try {
      final categoryId = state.selectedSubcategory?.id ?? parentCategoryId;
      final locations = await _repository.getAllLoactionsForCategoryWithFilters(
        categoryId,
        attributeFilters: attributeIds.isNotEmpty ? attributeIds : null,
      );
      emit(
        state.copyWith(
          areLocationsLoading: false,
          locations: locations,
          filteredLocations: _filterLocations(locations, state.searchQuery),
          selectedAttributeIds: attributeIds,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          areLocationsLoading: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  void clearAttributeFilters() {
    emit(state.copyWith(selectedAttributeIds: []));
    // Reload locations without filters
    if (state.selectedSubcategory != null) {
      selectSubcategory(state.selectedSubcategory!);
    }
  }

  void changeSearchQuery(String query) {
    final filteredLocations = _filterLocations(state.locations, query);
    emit(
      state.copyWith(searchQuery: query, filteredLocations: filteredLocations),
    );
  }

  List<LocationModel> _filterLocations(
    List<LocationModel> locations,
    String query,
  ) {
    if (query.isEmpty) return locations;

    final lowercaseQuery = query.toLowerCase();
    return locations.where((location) {
      return location.name.toLowerCase().contains(lowercaseQuery) ||
          (location.address?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (location.description?.toLowerCase().contains(lowercaseQuery) ??
              false) ||
          (location.attributeNames?.any(
                (attr) => attr.toLowerCase().contains(lowercaseQuery),
              ) ??
              false);
    }).toList();
  }
}
