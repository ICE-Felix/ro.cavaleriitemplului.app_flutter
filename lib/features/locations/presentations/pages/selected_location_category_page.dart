import 'package:app/core/cubit/location_cubit.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/selected_location_category/selected_location_category_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_list_view.dart';
import 'package:app/features/locations/presentations/widgets/location_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/permission_wrapper.dart';

class SelectedLocationCategoryPage extends StatelessWidget {
  const SelectedLocationCategoryPage({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return PermissionWrapper.location(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SelectedLocationCategoryCubit>(
            create: (context) {
              final cubit = SelectedLocationCategoryCubit(
                parentCategoryId: locationId,
              );
              Future.delayed(Duration.zero, () async {
                await cubit.initialize();
                await cubit.loadAttributeFilters();
              });
              return cubit;
            },
          ),
        ],
        child: const SelectedLocationPageView(),
      ),
    );
  }
}

class SelectedLocationPageView extends StatefulWidget {
  const SelectedLocationPageView({super.key});

  @override
  State<SelectedLocationPageView> createState() =>
      _SelectedLocationPageViewState();
}

class _SelectedLocationPageViewState extends State<SelectedLocationPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        showLogo: false,
        showBackButton: true,
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
        onLogoTap: () {},
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withValues(alpha: 0.1), Colors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, locationState) {
            return BlocBuilder<
              SelectedLocationCategoryCubit,
              SelectedLocationCategoryState
            >(
              builder: (context, categoryState) {
                // Show loading state while both cubits are initializing
                if (categoryState.isLoading && locationState.isLoading) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade50, Colors.purple.shade50],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(strokeWidth: 3),
                          SizedBox(height: 24),
                          Text(
                            'Loading locations and getting your position...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Modern Tab bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.primary,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(8),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.list_alt, size: 20),
                                  SizedBox(width: 8),
                                  Text('Locations'),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map, size: 20),
                                  SizedBox(width: 8),
                                  Text('Map'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tab content with modern styling
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade50),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Locations List Tab
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 5,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: const LocationListView(),
                              ),
                              // Map Tab
                              if (categoryState.vectorMapStyle != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.02,
                                        ),
                                        blurRadius: 5,
                                        offset: const Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: LocationMapWidget(
                                    style: categoryState.vectorMapStyle!,
                                    locations: categoryState.locations,
                                    currentLocation:
                                        locationState.currentLocation,
                                    isLocationLoading: locationState.isLoading,
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.map_outlined,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Map style not loaded',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
