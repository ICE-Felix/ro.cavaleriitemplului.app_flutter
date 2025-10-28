import 'package:app/core/services/location_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService _locationService;

  LocationCubit(this._locationService) : super(const LocationState());

  /// Initialize and get current location
  Future<void> initialize() async {
    if (state.hasLocation) return;
    emit(state.copyWith(isLoading: true));

    try {
      final location = await _locationService.getCurrentLocation();

      if (location != null) {
        emit(
          state.copyWith(
            isLoading: false,
            currentLocation: location,
            hasLocation: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          hasLocation: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// Refresh location (force new fetch)
  Future<void> refreshLocation() async {
    emit(state.copyWith(isLoading: true));

    try {
      final location = await _locationService.getCurrentLocation(
        forceRefresh: true,
      );

      emit(
        state.copyWith(
          isLoading: false,
          currentLocation: location,
          hasLocation: location != null,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          hasLocation: false,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
