import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:app/core/banners/widgets/banner_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/app_search_bar.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/locations_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_category_card.dart';
import 'package:app/features/locations/presentations/widgets/locations_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LocationsCategoriesPage extends StatelessWidget {
  const LocationsCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => BannersCubit()..loadBanners(page: BannerPage.venue),
        ),
        BlocProvider(create: (context) => LocationsCubit()..initialize()),
      ],
      child: BlocBuilder<LocationsCubit, LocationsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomTopBar.withCart(
              context: context,
              showNotificationButton: true,
              showLogo: true,
              logoHeight: 80,
              logoWidth: 120,
              logoPadding: const EdgeInsets.only(
                left: 20.0,
                top: 8.0,
                bottom: 8.0,
              ),
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
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Section
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: AppSearchBar(
                        hintText: 'Search locations',
                        onChanged:
                            (q) =>
                                context.read<LocationsCubit>().changeQuery(q),
                      ),
                    ),

                    // Banner Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: BannerWidget(type: BannerType.primary),
                    ),

                    const SizedBox(height: 16),

                    // Categories Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Location Categories',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          if (state.categories.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${state.categories.length}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Categories Grid
                    Builder(
                      builder: (context) {
                        if (state.isLoading) {
                          return Container(
                            height: 300,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text('Loading locations...'),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state.categories.isEmpty) {
                          return Container(
                            height: 400,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant
                                          .withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.location_off_rounded,
                                      size: 48,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No locations found',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try adjusting your search or check back later',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.0,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final location = state.categories[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 300 + (index * 100),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: LocationCategoryCard(
                                          location: location,
                                          onTap: () {
                                            context.pushNamed(
                                              AppRoutesNames
                                                  .selectedLocationCategory
                                                  .name,
                                              pathParameters: {
                                                'id': location.id,
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: BannerWidget(type: BannerType.secondary),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
