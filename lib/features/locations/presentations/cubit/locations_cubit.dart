import 'package:app/core/service_locator.dart';
import 'package:app/features/locations/data/models/location_category_model.dart';
import 'package:app/features/locations/domain/repositories/locations_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsState extends Equatable {
  final bool isLoading;
  final String query;
  final List<LocationCategoryModel> categories;
  final String bannerUrl;
  final String message;

  const LocationsState({
    this.isLoading = false,
    this.query = '',
    this.categories = const [],
    this.bannerUrl = '',
    this.message = '',
  });

  LocationsState copyWith({
    bool? isLoading,
    String? query,
    List<LocationCategoryModel>? categories,
    String? bannerUrl,
    String? message,
  }) {
    return LocationsState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      categories: categories ?? this.categories,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isLoading, query, categories, bannerUrl, message];
}

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(const LocationsState());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, message: ''));
    try {
      final repo = sl.get<LocationsRepository>();
      final categories = await repo.getAllParentCategories();
      final banner = await repo.getLocationsBannerUrl();
      emit(
        state.copyWith(
          isLoading: false,
          categories: categories,
          bannerUrl: banner,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: '$e'));
    }
  }

  void changeQuery(String value) {
    emit(state.copyWith(query: value));
  }
}
