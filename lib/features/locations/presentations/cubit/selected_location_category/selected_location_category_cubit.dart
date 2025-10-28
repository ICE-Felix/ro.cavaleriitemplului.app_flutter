import 'package:app/core/cubit/location_cubit.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/core/utils/map_utils.dart';
import 'package:app/core/utils/nullable.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

part 'selected_location_category_state.dart';

class SelectedLocationCategoryCubit
    extends Cubit<SelectedLocationCategoryState> {
  SelectedLocationCategoryCubit({required this.parentCategoryId})
    : super(SelectedLocationCategoryState());
  final LocationsRepository _repository = sl<LocationsRepository>();
  final String parentCategoryId;

  Future<void> initialize({
    bool nearby = true,
    int page = 1,
    int limit = 20,
  }) async {
    if (kDebugMode) {
      print('SelectedLocationCategoryCubit initialize');
    }
    emit(state.copyWith(isLoading: true));
    final location = sl<LocationCubit>().state.currentLocation;
    final latitude = location?.latitude;
    final longitude = location?.longitude;
    try {
      LocationCategoryModel? selectedSubcategory;
      final subcategories = await _repository.getAllSubCategories(
        parentCategoryId,
      );
      final vectorMapStyle =
          await StyleReader(uri: MapUtils.flutterMapTileProviderUrl).read();

      final List<LocationModel> locations = await _repository
          .getAllLoactionsForCategoryWithFilters(
            parentCategoryId,
            attributeFilters:
                state.selectedAttributeIds.isNotEmpty
                    ? state.selectedAttributeIds
                    : null,
            locationLatitude: latitude,
            locationLongitude: longitude,
            orderByDistance: nearby,
            radiusKm: state.radiusKm,
            page: page,
            limit: limit,
          );

      // Load initial map venues with current location
      if (latitude != null && longitude != null) {
        await loadMapVenues(
          latitude: latitude,
          longitude: longitude,
          radiusKm: 100, // Use 100km for initial map load
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          areLocationsLoading: false,
          locations: locations,
          filteredLocations: _filterLocations(locations, state.searchQuery),
          subCategories: subcategories,
          selectedSubcategory: Nullable(value: selectedSubcategory),
          vectorMapStyle: vectorMapStyle,
          currentPage: page,
          hasMorePages: locations.length == limit && locations.isNotEmpty,
          totalLocations: locations.length,
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

  Future<void> selectSubcategory(LocationCategoryModel? subcategory) async {
    print('selectSubcategory: $subcategory');
    emit(state.copyWith(areLocationsLoading: true));
    try {
      final locations = await _repository.getAllLoactionsForCategory(
        subcategory?.id ?? parentCategoryId,
      );
      emit(
        state.copyWith(
          isLoading: false,
          areLocationsLoading: false,
          locations: locations,
          filteredLocations: _filterLocations(locations, state.searchQuery),
          selectedSubcategory: Nullable(value: subcategory),
          currentPage: 1,
          hasMorePages: true,
          totalLocations: locations.length,
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
      final location = sl<LocationCubit>().state.currentLocation;
      final locations = await _repository.getAllLoactionsForCategoryWithFilters(
        categoryId,
        attributeFilters: attributeIds.isNotEmpty ? attributeIds : null,
        locationLatitude: location?.latitude,
        locationLongitude: location?.longitude,
        orderByDistance: true,
        radiusKm: state.radiusKm,
      );
      emit(
        state.copyWith(
          areLocationsLoading: false,
          locations: locations,
          filteredLocations: _filterLocations(locations, state.searchQuery),
          selectedAttributeIds: attributeIds,
          currentPage: 1,
          hasMorePages: true,
          totalLocations: locations.length,
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

  /// Load locations with location-based filtering and pagination
  Future<void> loadLocationsWithLocationFilter({
    required double latitude,
    required double longitude,
    bool nearby = true,
    int page = 1,
    int limit = 10,
  }) async {
    // Prevent overlap: if already loading initial page or loading more, skip
    if ((page == 1 && state.areLocationsLoading) ||
        (page > 1 && state.isLoadingMore)) {
      return;
    }
    if (page == 1) {
      emit(state.copyWith(areLocationsLoading: true));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    try {
      final categoryId = state.selectedSubcategory?.id ?? parentCategoryId;
      final newLocations = await _repository
          .getAllLoactionsForCategoryWithFilters(
            categoryId,
            attributeFilters:
                state.selectedAttributeIds.isNotEmpty
                    ? state.selectedAttributeIds
                    : null,
            locationLatitude: latitude,
            locationLongitude: longitude,
            orderByDistance: nearby,
            radiusKm: state.radiusKm,
            page: page,
            limit: limit,
          );

      final allLocations =
          page == 1 ? newLocations : [...state.locations, ...newLocations];

      emit(
        state.copyWith(
          areLocationsLoading: false,
          isLoadingMore: false,
          locations: allLocations,
          filteredLocations: _filterLocations(allLocations, state.searchQuery),
          currentPage: page,
          // Only mark more pages if this page returned a full page
          hasMorePages: newLocations.length == limit && newLocations.isNotEmpty,
          totalLocations: allLocations.length,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          areLocationsLoading: false,
          isLoadingMore: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  /// Load more locations for pagination
  Future<void> loadMoreLocations({
    required double latitude,
    required double longitude,
    bool nearby = true,
    int limit = 20,
  }) async {
    if (!state.hasMorePages || state.isLoadingMore) return;

    await loadLocationsWithLocationFilter(
      latitude: latitude,
      longitude: longitude,
      nearby: nearby,
      page: state.currentPage + 1,
      limit: limit,
    );
  }

  void changeSearchQuery(String query) {
    final filteredLocations = _filterLocations(state.locations, query);
    emit(
      state.copyWith(searchQuery: query, filteredLocations: filteredLocations),
    );
  }

  void updateRadius(int radiusKm) {
    emit(state.copyWith(radiusKm: radiusKm));
  }

  /// Load venues for map center position
  Future<void> loadMapVenues({
    required double latitude,
    required double longitude,
    int? radiusKm,
  }) async {
    try {
      final categoryId = state.selectedSubcategory?.id ?? parentCategoryId;
      final mapRadius =
          radiusKm ??
          MapUtils.defaultRadiusKmForMap; // Default to 100km for map viewport

      final venues = await _repository.getAllLoactionsForCategoryWithFilters(
        categoryId,
        attributeFilters:
            state.selectedAttributeIds.isNotEmpty
                ? state.selectedAttributeIds
                : null,
        locationLatitude: latitude,
        locationLongitude: longitude,
        orderByDistance: true,
        radiusKm: mapRadius,
        page: 1,
        limit: 100, // Maximum 100 venues for map
      );

      emit(state.copyWith(mapVenues: venues));
    } catch (e) {
      // Silently fail for map venues - don't show error to user
      if (kDebugMode) {
        print('Error loading map venues: $e');
      }
    }
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
