import 'package:app/core/cubit/location_cubit.dart';
import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/app_search_bar.dart';
import 'package:app/core/widgets/category_horizontal_slider.dart';
import 'package:app/core/widgets/location_filter_button.dart';
import 'package:app/core/widgets/location_filters_modal/location_filters_modal.dart';
import 'package:app/features/locations/presentations/cubit/selected_location_category/selected_location_category_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LocationListView extends StatelessWidget {
  const LocationListView({super.key});

  void _showFiltersModal(
    BuildContext context,
    SelectedLocationCategoryState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => LocationFiltersModal(
            attributeFilters: state.attributeFilters,
            selectedAttributeIds: state.selectedAttributeIds,
            radiusKm: state.radiusKm,
            onApplyFilters: (attributeIds) {
              context
                  .read<SelectedLocationCategoryCubit>()
                  .applyAttributeFilters(attributeIds);
            },
            onRadiusChanged: (radiusKm) {
              context.read<SelectedLocationCategoryCubit>().updateRadius(
                radiusKm,
              );
            },
            onClearFilters: () {
              context
                  .read<SelectedLocationCategoryCubit>()
                  .clearAttributeFilters();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<
          SelectedLocationCategoryCubit,
          SelectedLocationCategoryState
        >(
          builder: (context, categoryState) {
            if (categoryState.isLoading || locationState.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading locations and getting your position...'),
                  ],
                ),
              );
            }
            if (categoryState.isError) {
              return Center(
                child: Text(categoryState.errorMessage ?? 'An error occurred'),
              );
            }
            return Column(
              children: [
                // Search and Filter Row
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppSearchBar(
                          hintText: context.getString(
                            label: 'locations.searchLocations',
                          ),
                          onChanged: (query) {
                            context
                                .read<SelectedLocationCategoryCubit>()
                                .changeSearchQuery(query);
                          },
                          margin: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 12),
                      LocationFilterButton(
                        selectedFiltersCount:
                            categoryState.selectedAttributeIds.length,
                        onTap: () => _showFiltersModal(context, categoryState),
                      ),
                    ],
                  ),
                ),
                CategoryHorizontalSlider(
                  showAllButton: true,
                  items: categoryState.subCategories,
                  itemsPerPage: 3,
                  getDisplayName: (category) => category.name,
                  onSelectionChanged: (category) async {
                    await context
                        .read<SelectedLocationCategoryCubit>()
                        .selectSubcategory(category);
                  },
                ),
                SizedBox(height: 16),
                if (categoryState.areLocationsLoading)
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                if (categoryState.areLocationsLoading == false &&
                    categoryState.filteredLocations.isNotEmpty)
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        final atEnd =
                            scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200;
                        if (atEnd &&
                            categoryState.hasMorePages &&
                            !categoryState.isLoadingMore &&
                            !categoryState.areLocationsLoading &&
                            locationState.currentLocation != null) {
                          // Load more locations when reaching the bottom
                          context
                              .read<SelectedLocationCategoryCubit>()
                              .loadMoreLocations(
                                latitude:
                                    locationState.currentLocation!.latitude,
                                longitude:
                                    locationState.currentLocation!.longitude,
                                nearby: true,
                              );
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount:
                            categoryState.filteredLocations.length +
                            (categoryState.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the bottom when loading more
                          if (index == categoryState.filteredLocations.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return LocationListItem(
                            location: categoryState.filteredLocations[index],
                            currentLocation: locationState.currentLocation,
                            onTap: () {
                              context.pushNamed(
                                AppRoutesNames.locationsDetails.name,
                                pathParameters: {
                                  'id':
                                      categoryState.filteredLocations[index].id,
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                if (categoryState.areLocationsLoading == false &&
                    categoryState.filteredLocations.isEmpty &&
                    categoryState.locations.isNotEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.getString(
                              label: 'locations.noLocationsFound',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.getString(
                              label: 'locations.tryAdjustingSearch',
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (categoryState.areLocationsLoading == false &&
                    categoryState.filteredLocations.isEmpty &&
                    categoryState.locations.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.getString(
                              label: 'locations.noLocationsNearYou',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.getString(
                              label: 'locations.tryExpandingRange',
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
