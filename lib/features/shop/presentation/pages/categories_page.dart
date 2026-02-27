import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:app/core/banners/widgets/banner_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/presentation/cubit/categories/categories_cubit.dart';
import 'package:app/features/shop/presentation/widgets/category_card.dart';
import 'package:app/core/widgets/app_search_bar_v2.dart';
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
            logoHeight: 200,
            logoWidth: 0,
            centerTitle: false,
            showNotificationButton: true,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoriesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Nu am putut încărca magazinul',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verifică conexiunea la internet și încearcă din nou.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<CategoriesCubit>().loadCategories();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reîncearcă'),
              ),
            ],
          ),
        ),
      );
    }

    final categories = state.categories;

    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Magazinul este gol momentan',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Revino mai târziu pentru produse noi.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        // Search bar
        GestureDetector(
          onTap: () {
            context.pushNamed(AppRoutesNames.searchProducts.name);
          },
          child: AbsorbPointer(
            child: AppSearchBarV2(
              controller: TextEditingController(),
              hintText: 'Caută produse...',
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            ),
          ),
        ),
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
}
