import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:app/core/banners/widgets/banner_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BannersCubit()..loadBanners(page: BannerPage.shop),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit()..loadCategories(),
        ),
      ],
      child: const _CategoriesPageView(),
    );
  }
}

class _CategoriesPageView extends StatelessWidget {
  const _CategoriesPageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return Scaffold(
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
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoriesState state) {
    print('🎨 UI: Building body with state: ${state.runtimeType}');

    if (state is CategoriesLoading) {
      print('🎨 UI: Showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CategoriesError) {
      print('🎨 UI: Showing error: ${state.message}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<CategoriesCubit>().retry();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is CategoriesLoaded) {
      final categories = state.categories;
      print('🎨 UI: Showing ${categories.length} categories');
      for (var cat in categories) {
        print('   🎨 UI: - ${cat.name} (image: ${cat.image ?? "null"})');
      }

      return ListView(
        children: [
          // Search bar at the top
          ButtonSearchBar(
            onTap: () {
              context.pushNamed(AppRoutesNames.searchProducts.name);
            },
            margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          ),
          const SizedBox(height: 16),
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
      );
    }

    return const SizedBox.shrink();
  }
}
