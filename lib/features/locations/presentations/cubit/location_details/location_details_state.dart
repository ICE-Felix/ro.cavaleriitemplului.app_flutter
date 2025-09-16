part of 'location_details_cubit.dart';

class LocationDetailsState extends Equatable {
  const LocationDetailsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.location,
  });
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final LocationModel? location;

  LocationDetailsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    LocationModel? location,
  }) {
    return LocationDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, location];
}
