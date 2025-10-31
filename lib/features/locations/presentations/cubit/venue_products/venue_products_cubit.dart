import 'package:app/core/service_locator.dart';
import 'package:app/features/locations/data/models/venue_product_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'venue_products_state.dart';

class VenueProductsCubit extends Cubit<VenueProductsState> {
  final LocationsRepository _repository;

  VenueProductsCubit({LocationsRepository? repository})
      : _repository = repository ?? sl.get<LocationsRepository>(),
        super(const VenueProductsState());

  Future<void> getVenueProducts(String venueId) async {
    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    try {
      final products = await _repository.getVenueProducts(venueId);

      emit(state.copyWith(
        isLoading: false,
        isError: false,
        errorMessage: null,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearProducts() {
    emit(const VenueProductsState());
  }
}
