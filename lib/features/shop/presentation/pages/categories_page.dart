import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:app/core/banners/widgets/banner_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/presentation/cubit/categories/categories_cubit.dart';
import 'package:app/features/shop/presentation/widgets/category_card.dart';
import 'package:app/features/shop/presentation/widgets/button_search_bar.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit()..loadCategories(),
      child: const _CategoriesPageView(),
    );
  }
}

class _CategoriesPageView extends StatefulWidget {
  const _CategoriesPageView();

  @override
  State<_CategoriesPageView> createState() => _CategoriesPageViewState();
}

class _CategoriesPageViewState extends State<_CategoriesPageView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannersCubit()..loadBanners(page: BannerPage.shop),
      child: Scaffold(
        appBar: CustomTopBar.withCart(
          context: context,
          showLogo: true,
          logoHeight: 90,
          logoWidth: 140,
          logoPadding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          showNotificationButton: true,
          onNotificationTap: () {
            // Handle notification tap
          },
          onLogoTap: () {},
        ),
        body: ListView(
          children: [
            // Search bar at the top
            ButtonSearchBar(
              onTap: () {
                context.pushNamed(AppRoutesNames.searchProducts.name);
              },
              margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            ),
            const SizedBox(height: 16),
            // Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: BannerWidget(type: BannerType.primary),
            ),
            const SizedBox(height: 16),
            // Categories content
            Expanded(
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  if (state is CategoriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoriesLoaded) {
                    if (state.categories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No categories available', // TODO: Use localized string
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CategoriesCubit>().retry();
                              },
                              child: const Text(
                                'Retry',
                              ), // TODO: Use localized string
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () {
                            context.pushNamed(
                              AppRoutesNames.products.name,
                              extra: category,
                            );
                          },
                        );
                      },
                    );
                  } else if (state is CategoriesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CategoriesCubit>().retry();
                            },
                            child: const Text(
                              'Retry',
                            ), // TODO: Use localized string
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            const SizedBox(height: 16),
            // Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: BannerWidget(type: BannerType.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
