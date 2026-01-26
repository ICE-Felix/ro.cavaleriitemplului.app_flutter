import 'package:app/core/navigation/routes_name.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/presentation/cubit/products/products_cubit.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  final ProductCategoryEntity category;

  const ProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(parentCategoryId: category.id)..initialize(),
      child: _ProductsPageView(category: category),
    );
  }
}

class _ProductsPageView extends StatelessWidget {
  final ProductCategoryEntity category;

  const _ProductsPageView({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        title: category.name,
        showBackButton: true,
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          print('🎨 ProductsPage: Building with state - isLoading: ${state.isLoading}, isError: ${state.isError}, products: ${state.products.length}');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductsSearchBar(
                onChanged: (query) {
                  print('🎨 ProductsPage: Search query changed to: $query');
                  context.read<ProductsCubit>().changeSearchQuery(query);
                },
              ),
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    // Show loading
    if (state.isLoading) {
      print('🎨 ProductsPage: Showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    // Show error
    if (state.isError) {
      print('🎨 ProductsPage: Showing error: ${state.message}');
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
              state.message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('🎨 ProductsPage: Retry button pressed');
                context.read<ProductsCubit>().getProducts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (state.products.isEmpty) {
      print('🎨 ProductsPage: Showing empty state');
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                state.searchQuery.isEmpty
                    ? 'Nu sunt produse disponibile'
                    : 'Nu s-au găsit produse pentru "${state.searchQuery}"',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show products
    print('🎨 ProductsPage: Showing ${state.products.length} products');
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        return ProductCard(
          product: product,
          onTap: () {
            context.pushNamed(
              AppRoutesNames.productDetails.name,
              extra: product,
            );
          },
        );
      },
    );
  }
}
