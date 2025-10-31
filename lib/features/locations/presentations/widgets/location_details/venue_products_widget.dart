import 'package:app/core/localization/app_localization.dart';
import 'package:app/features/locations/data/models/venue_product_model.dart';
import 'package:app/features/locations/presentations/cubit/venue_products/venue_products_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_details/venue_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueProductsWidget extends StatelessWidget {
  const VenueProductsWidget({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VenueProductsCubit()..getVenueProducts(venueId),
      child: BlocBuilder<VenueProductsCubit, VenueProductsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _LoadingView();
          }

          if (state.isError) {
            return _ErrorView(
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<VenueProductsCubit>().getVenueProducts(venueId);
              },
            );
          }

          if (state.products.isEmpty) {
            return const _EmptyView();
          }

          return _ProductsListView(products: state.products);
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onRetry});

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'An error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            context.getString(label: 'locations.no_products_available'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.getString(label: 'locations.no_products_description'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductsListView extends StatelessWidget {
  const _ProductsListView({required this.products});

  final List<VenueProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            context.getString(label: 'locations.venue_products'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = products[index];
            return VenueProductCard(product: product);
          },
        ),
      ],
    );
  }
}
