import 'package:app/core/service_locator.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_locations_state.dart';

class SearchLocationsCubit extends Cubit<SearchLocationsState> {
  final LocationsRepository _repository;

  SearchLocationsCubit({LocationsRepository? repository})
      : _repository = repository ?? sl.get<LocationsRepository>(),
        super(const SearchLocationsState());

  Future<void> searchLocations({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    // If it's a new search (page 1), reset state
    if (page == 1) {
      emit(state.copyWith(
        isLoading: true,
        isError: false,
        errorMessage: null,
        searchQuery: query,
        locations: [],
        currentPage: 1,
        hasMorePages: true,
        totalLocations: 0,
      ));
    } else {
      // If loading more pages, set loading more state
      emit(state.copyWith(isLoadingMore: true));
    }

    try {
      final newLocations = await _repository.searchAllLocations(
        query: query.isNotEmpty ? query : null,
        page: page,
        limit: limit,
      );

      final allLocations =
          page == 1 ? newLocations : [...state.locations, ...newLocations];

      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isError: false,
        errorMessage: null,
        locations: allLocations,
        currentPage: page,
        hasMorePages: newLocations.length == limit && newLocations.isNotEmpty,
        totalLocations: allLocations.length,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMoreLocations({
    int limit = 20,
  }) async {
    if (!state.hasMorePages || state.isLoadingMore) return;

    await searchLocations(
      query: state.searchQuery,
      page: state.currentPage + 1,
      limit: limit,
    );
  }

  void clearSearch() {
    emit(const SearchLocationsState());
  }

  void retry() {
    if (state.searchQuery.isNotEmpty) {
      searchLocations(
        query: state.searchQuery,
        page: 1,
      );
    }
  }
}
