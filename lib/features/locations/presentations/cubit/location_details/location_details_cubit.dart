import 'package:app/core/service_locator.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_details_state.dart';

class LocationDetailsCubit extends Cubit<LocationDetailsState> {
  LocationDetailsCubit() : super(LocationDetailsState());

  Future<void> getLocationDetails(String locationId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final location = await sl.get<LocationsRepository>().getLocationById(locationId);
      emit(state.copyWith(isLoading: false, location: location));
    } catch (e) {
      emit(state.copyWith(isError: true, errorMessage: e.toString()));
    }
  }
}
