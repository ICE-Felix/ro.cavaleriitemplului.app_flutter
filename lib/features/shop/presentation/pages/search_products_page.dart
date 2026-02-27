import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/app_search_bar_v2.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/presentation/cubit/search_products/search_products_cubit.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: CustomTopBar.withCart(
        context: context,
        showNotificationButton: true,
        showLogo: false,
        showBackButton: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      ),
      body: BlocProvider(
        create: (context) => SearchProductsCubit(),
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                AppSearchBarV2(
                  controller: _searchController,
                  hintText: 'Caută produse...',
                  autofocus: true,
                  margin: const EdgeInsets.all(16.0),
                  onChanged: (query) {
                    context.read<SearchProductsCubit>().searchProducts(query);
                  },
                ),
                Expanded(
                  child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.error != null) {
                        return Center(
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state.products.isEmpty) {
                        return Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'Caută produse în magazin'
                                : 'Nu s-au găsit produse',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: state.products.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
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
