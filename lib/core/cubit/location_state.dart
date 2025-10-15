part of 'location_cubit.dart';

class LocationState extends Equatable {
  const LocationState({
    this.isLoading = false,
    this.currentLocation,
    this.hasLocation = false,
    this.error,
  });

  final bool isLoading;
  final LatLng? currentLocation;
  final bool hasLocation;
  final String? error;

  LocationState copyWith({
    bool? isLoading,
    LatLng? currentLocation,
    bool? hasLocation,
    String? error,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      hasLocation: hasLocation ?? this.hasLocation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, currentLocation, hasLocation, error];
}

