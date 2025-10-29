import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/search_locations/search_locations_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_list_item.dart';
import 'package:app/features/locations/presentations/widgets/locations_search_bar.dart';
import 'package:app/features/locations/presentations/widgets/search_locations/search_locations_empty_query.dart';
import 'package:app/features/locations/presentations/widgets/search_locations/search_locations_empty_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchLocationsPage extends StatefulWidget {
  const SearchLocationsPage({super.key});

  @override
  State<SearchLocationsPage> createState() => _SearchLocationsPageState();
}

class _SearchLocationsPageState extends State<SearchLocationsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        showNotificationButton: true,
        showLogo: false,
        showBackButton: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      ),
      body: BlocProvider(
        create: (context) => SearchLocationsCubit(),
        child: BlocBuilder<SearchLocationsCubit, SearchLocationsState>(
          builder: (context, state) {
            return Column(
              children: [
                // Search bar at the top
                LocationsSearchBar(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (query) {
                    context.read<SearchLocationsCubit>().searchLocations(
                      query: query,
                    );
                  },
                  onClear: () {
                    context.read<SearchLocationsCubit>().clearSearch();
                  },
                  onSubmitted: () {
                    if (_searchController.text.isNotEmpty) {
                      context.read<SearchLocationsCubit>().searchLocations(
                        query: _searchController.text,
                      );
                    }
                  },
                  margin: const EdgeInsets.all(16.0),
                ),

                // Search results area
                Expanded(
                  child: BlocBuilder<
                    SearchLocationsCubit,
                    SearchLocationsState
                  >(
                    buildWhen:
                        (previous, current) =>
                            previous.locations != current.locations ||
                            previous.isLoading != current.isLoading ||
                            previous.isError != current.isError ||
                            previous.searchQuery != current.searchQuery,
                    builder: (context, state) {
                      if (state.searchQuery.isEmpty) {
                        return const SearchLocationsEmptyQuery();
                      }
                      if (state.isError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Something went wrong',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.errorMessage ?? 'An error occurred',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<SearchLocationsCubit>().retry();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.locations.isEmpty && !state.isLoading) {
                        return const SearchLocationsEmptyResult();
                      }
                      if (state.isLoading && state.locations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                context.getString(label: 'locations.searching'),
                              ),
                            ],
                          ),
                        );
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          final atEnd =
                              scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200;
                          if (atEnd &&
                              state.hasMorePages &&
                              !state.isLoadingMore &&
                              !state.isLoading) {
                            // Load more locations when reaching the bottom
                            context
                                .read<SearchLocationsCubit>()
                                .loadMoreLocations();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount:
                              state.locations.length +
                              (state.isLoadingMore ? 1 : 0),
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the bottom when loading more
                            if (index == state.locations.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final location = state.locations[index];
                            return LocationListItem(
                              location: location,
                              currentLocation: null,
                              onTap: () {
                                context.pushNamed(
                                  AppRoutesNames.locationsDetails.name,
                                  pathParameters: {'id': location.id},
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
