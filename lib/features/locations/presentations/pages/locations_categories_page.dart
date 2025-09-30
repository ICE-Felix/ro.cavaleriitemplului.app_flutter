import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/localization/widgets/language_switcher_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/app_search_bar.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/locations_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_category_card.dart';
import 'package:app/features/locations/presentations/widgets/locations_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LocationsCategoriesPage extends StatelessWidget {
  const LocationsCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationsCubit()..initialize(),
      child: BlocBuilder<LocationsCubit, LocationsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomTopBar(
              showProfileButton: true,
              showNotificationButton: false,
              showLogo: true,
              logoHeight: 90,
              logoWidth: 140,
              logoPadding: const EdgeInsets.only(
                left: 20.0,
                top: 10.0,
                bottom: 10.0,
              ),
              notificationCount: 0,
              onProfileTap: () {},
              onNotificationTap: () {
                // Handle notification tap
              },
              onLogoTap: () {},
              customActions: [
                // Language switcher button
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: LanguageSwitcherWidget(isCompact: true),
                ),
                // Saved articles button
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed(AppRoutesNames.savedArticles.name);
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.solidBookmark,
                      size: 20,
                    ),
                    tooltip: context.getString(label: 'savedArticles'),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppSearchBar(
                    hintText: 'Search locations',
                    onChanged:
                        (q) => context.read<LocationsCubit>().changeQuery(q),
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LocationsBanner(imageUrl: state.bannerUrl),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 500,
                    child: Builder(
                      builder: (context) {
                        // debug: categories count
                        // print(state.categories.length);
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.categories.isEmpty) {
                          return const Center(
                            child: Text('No locations found'),
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final location = state.categories[index];
                            return LocationCategoryCard(
                              location: location,
                              onTap: () {
                                context.pushNamed(
                                  AppRoutesNames.selectedLocationCategory.name,
                                  pathParameters: {'id': location.id},
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
