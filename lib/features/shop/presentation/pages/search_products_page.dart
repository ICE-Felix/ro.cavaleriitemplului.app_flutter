import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/presentation/cubit/search_products/search_products_cubit.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
import 'package:app/features/shop/presentation/widgets/search_products/search_products_empty_query.dart';
import 'package:app/features/shop/presentation/widgets/search_products/search_products_empty_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({super.key});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        showProfileButton: true,
        showNotificationButton: true,
        showLogo: false,
        showBackButton: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        notificationCount: 0,
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
      body: BlocProvider(
        create: (context) => SearchProductsCubit(),
        child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
          builder: (context, state) {
            return Column(
              children: [
                // Search bar at the top
                ProductsSearchBar(
                  controller: _searchController,
                  autofocus: true,
                  onChanged:
                      (query) => context
                          .read<SearchProductsCubit>()
                          .searchProducts(query),
                  onClear:
                      () => context.read<SearchProductsCubit>().clearSearch(),
                  onSubmitted:
                      () => context.read<SearchProductsCubit>().searchProducts(
                        _searchController.text,
                      ),
                  margin: const EdgeInsets.all(16.0),
                ),

                // Search results area
                Expanded(
                  child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                    buildWhen:
                        (previous, current) =>
                            previous.products != current.products ||
                            previous.isLoading != current.isLoading ||
                            previous.isError != current.isError ||
                            previous.searchQuery != current.searchQuery,
                    builder: (context, state) {
                      if (state.searchQuery.isEmpty) {
                        return SearchProductsEmptyQuery();
                      }
                      if (state.products.isEmpty) {
                        return SearchProductsEmptyResult();
                      }
                      if (state.isLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(context.getString(label: 'shop.searching')),
                            ],
                          ),
                        );
                      }
                      // ToDO -> add error state
                      return ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: state.products.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 8),
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
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
