import 'package:app/core/navigation/routes_name.dart';
import 'package:app/features/shop/presentation/widgets/multi_select_dropdown.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/presentation/cubit/products/products_cubit.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  final ProductCategoryEntity category;

  const ProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()..getProducts(category.id),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(title: widget.category.name, showBackButton: true),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return Column(
            children: [
              ProductsSearchBar(
                onChanged: (query) {
                  context.read<ProductsCubit>().getProducts(
                    widget.category.id,
                    searchQuery: query,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MultiSelectDropdown<ProductCategoryEntity, int>(
                  items: state.subCategories,
                  hintText: 'Choose categories',
                  builderFunction: (ProductCategoryEntity category) {
                    return Text(category.name);
                  },
                  valueExtractor:
                      (ProductCategoryEntity category) => category.id,
                  onChanged: (List<int> selectedIds) {
                    context.read<ProductsCubit>().getProducts(
                      widget.category.id,
                      selectedSubCategoriesIds: selectedIds,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.isError == false) {
                      if (state.products.isEmpty) {
                        return Center(
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
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ProductsCubit>().retry(
                                    widget.category.id,
                                  );
                                },
                                child: const Text(
                                  'Retry',
                                ), // TODO: Use localized string
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
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
                                context.read<ProductsCubit>().retry(
                                  widget.category.id,
                                );
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
            ],
          );
        },
      ),
    );
  }
}
