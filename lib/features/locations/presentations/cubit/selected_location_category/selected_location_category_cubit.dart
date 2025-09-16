import 'package:app/core/service_locator.dart';
import 'package:app/core/utils/nullable.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      emit(
        state.copyWith(
          isLoading: false,
          locations: locations,
          subCategories: subcategories,
          selectedSubcategory: Nullable(value: selectedSubcategory),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: Nullable(value: e.toString()),
        ),
      );
    }
  }

  Future<void> selectSubcategory(LocationCategoryModel subcategory) async {
    emit(state.copyWith(areLocationsLoading: true));
    try {
      final locations = await _repository.getAllLoactionsForCategory(
        subcategory.id,
      );
      emit(
        state.copyWith(
          isLoading: false,
          areLocationsLoading: false,
          locations: locations,
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
}
