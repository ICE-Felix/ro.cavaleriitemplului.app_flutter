import 'package:app/core/navigation/routes_name.dart';
import 'package:app/features/shop/data/mock/mock_products.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/presentation/widgets/product_card.dart';
import 'package:app/features/shop/presentation/widgets/products_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  final ProductCategoryEntity category;

  const ProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return _ProductsPageView(category: category);
  }
}

class _ProductsPageView extends StatefulWidget {
  final ProductCategoryEntity category;

  const _ProductsPageView({required this.category});

  @override
  State<_ProductsPageView> createState() => _ProductsPageViewState();
}

class _ProductsPageViewState extends State<_ProductsPageView> {
  String _searchQuery = '';
  List<ProductEntity> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _filteredProducts = MockProducts.searchProducts(
        _searchQuery,
        categoryId: widget.category.id,
      );
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _loadProducts();
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductsSearchBar(
            onChanged: _onSearchChanged,
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Padding(
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
                            _searchQuery.isEmpty
                                ? 'Nu sunt produse disponibile'
                                : 'Nu s-au găsit produse pentru "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
