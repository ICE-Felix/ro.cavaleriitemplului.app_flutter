import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/presentation/cubit/search_products/cubit/search_products_cubit.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
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
  String _searchQuery = '';
  bool _isSearching = false;
  List<String> _searchResults =
      []; // This will be replaced with actual product search results

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    // TODO: Implement actual search functionality with your search use case
    // This is a placeholder implementation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _searchQuery == query) {
        setState(() {
          _isSearching = false;
          // Mock search results - replace with actual search logic
          _searchResults = [
            'Search result 1 for "$query"',
            'Search result 2 for "$query"',
            'Search result 3 for "$query"',
          ];
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
      _isSearching = false;
    });
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
                  onClear: _clearSearch,
                  onSubmitted: () => _performSearch(_searchController.text),
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
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                context.getString(label: 'shop.noResultsFound'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.getString(
                                  label: 'shop.trySearchingElse',
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
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
                          // return Card(
                          //   margin: const EdgeInsets.only(bottom: 8.0),
                          //   child: ListTile(
                          //     leading: const Icon(Icons.shopping_bag_outlined),
                          //     title: Text(product.name),
                          //     subtitle: Text(product.description),
                          //     onTap: () {
                          //       // TODO: Navigate to product details
                          //     },
                          //   ),
                          // );
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

  Widget _buildSearchContent() {
    if (_searchQuery.isEmpty) {
      return _buildEmptyState();
    }

    if (_isSearching) {
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

    if (_searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return _buildSearchResults();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.getString(label: 'shop.searchProducts'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.getString(label: 'shop.startTypingToSearch'),
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.getString(label: 'shop.noResultsFound'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.getString(label: 'shop.trySearchingElse'),
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: Text(result),
            subtitle: Text(context.getString(label: 'shop.description')),
            onTap: () {
              // TODO: Navigate to product details
            },
          ),
        );
      },
    );
  }
}
