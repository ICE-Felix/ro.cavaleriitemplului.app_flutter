import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/localization/widgets/language_switcher_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/app_search_bar.dart';
import 'package:app/core/widgets/category_horizontal_slider.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/selected_location_category/selected_location_category_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SelectedLocationCategoryPage extends StatelessWidget {
  const SelectedLocationCategoryPage({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelectedLocationCategoryCubit>(
      create:
          (context) =>
              SelectedLocationCategoryCubit(parentCategoryId: locationId)
                ..initialize(),
      child: const SelectedLocationPageView(),
    );
  }
}

class SelectedLocationPageView extends StatelessWidget {
  const SelectedLocationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        showProfileButton: true,
        showNotificationButton: true,
        showLogo: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
              icon: const FaIcon(FontAwesomeIcons.solidBookmark, size: 20),
              tooltip: context.getString(label: 'savedArticles'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<
        SelectedLocationCategoryCubit,
        SelectedLocationCategoryState
      >(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isError) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }
          return Column(
            children: [
              AppSearchBar(
                hintText: 'Search locations',
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              ),
              CategoryHorizontalSlider(
                items: state.subCategories,
                itemsPerPage: 3,
                getDisplayName: (category) => category.name,
                onSelectionChanged:
                    (category) => context
                        .read<SelectedLocationCategoryCubit>()
                        .selectSubcategory(category!),
              ),
              if (state.areLocationsLoading)
                Expanded(
                  child: const Center(child: CircularProgressIndicator()),
                ),
              if (state.areLocationsLoading == false &&
                  state.locations.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.locations.length,
                    itemBuilder:
                        (context, index) => LocationListItem(
                          location: state.locations[index],
                          onTap: () {
                            context.pushNamed(
                              AppRoutesNames.locationsDetails.name,
                              pathParameters: {'id': state.locations[index].id},
                            );
                          },
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
