import 'package:app/core/navigation/routes_name.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
import 'package:app/features/shop/presentation/widgets/product_filters/products_filter_button.dart';
import 'package:app/features/shop/presentation/widgets/product_filters/product_filters_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/presentation/cubit/products/products_cubit.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  final ProductCategoryEntity category;

  const ProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProductsCubit(parentCategoryId: category.id)..initialize(),
      child: _ProductsPageView(category: category),
    );
  }
}

class _ProductsPageView extends StatefulWidget {
  final ProductCategoryEntity category;

  const _ProductsPageView({required this.category});

  @override
  State<_ProductsPageView> createState() => _ProductsPageViewState();
}

class _ProductsPageViewState extends State<_ProductsPageView> {
  void _showFiltersModal(BuildContext parentContext, ProductsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ProductFiltersModal(
            categories: state.subCategories,
            tags: state.productTags,
            selectedCategoryIds: state.selectedSubCategoriesIds,
            selectedTagIds: state.selectedProductTagsIds,
            onApplyFilters: (categoryIds, tagIds) {
              parentContext
                  .read<ProductsCubit>()
                  .changeSelectedSubCategoriesIds(categoryIds);
              parentContext.read<ProductsCubit>().changeSelectedProductTagsIds(
                tagIds,
              );
            },
            onClearFilters: () {
              parentContext
                  .read<ProductsCubit>()
                  .changeSelectedSubCategoriesIds([]);
              parentContext.read<ProductsCubit>().changeSelectedProductTagsIds(
                [],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        title: widget.category.name,
        showBackButton: true,
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductsSearchBar(
                onChanged: (query) {
                  context.read<ProductsCubit>().changeSearchQuery(query);
                },
              ),
              ProductsFilterButton(
                selectedFiltersCount:
                    state.selectedSubCategoriesIds.length +
                    state.selectedProductTagsIds.length,
                onTap: () => _showFiltersModal(context, state),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.isError == false) {
                      if (state.products.isEmpty) {
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
                                const Text(
                                  'No products available', // TODO: Use localized string
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 8),
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
                    } else if (state.isError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                  context.read<ProductsCubit>().getProducts();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
