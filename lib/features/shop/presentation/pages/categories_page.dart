import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:app/core/banners/widgets/banner_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/data/mock/mock_categories.dart';
import 'package:app/features/shop/presentation/widgets/category_card.dart';
import 'package:app/features/shop/presentation/widgets/button_search_bar.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CategoriesPageView();
  }
}

class _CategoriesPageView extends StatelessWidget {
  const _CategoriesPageView();

  @override
  Widget build(BuildContext context) {
    // Load mock categories
    final categories = MockCategories.getMockCategories();

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
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   child: BannerWidget(type: BannerType.primary),
            // ),
            const SizedBox(height: 16),
            // Categories content
            GridView.builder(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
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
