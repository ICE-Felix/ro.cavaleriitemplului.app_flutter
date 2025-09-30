import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';

class NavigationMenu extends StatelessWidget {
  final Widget child;
  final String currentLocation;
  final BuildContext parentContext;

  const NavigationMenu({
    super.key,
    required this.child,
    required this.currentLocation,
    required this.parentContext,
  });

  int _canNavigate() {
    if (currentLocation == '/news') {
      return 0;
    } else if (currentLocation == '/locations') {
      return 1;
    } else if (currentLocation == '/shop') {
      return 2;
    } else if (currentLocation == '/events') {
      return 3;
    } else if (currentLocation == '/cart') {
      return 4;
    }
    // Default to news
    return -1;
  }

  int _getCurrentIndex() {
    if (currentLocation.startsWith('/news')) {
      return 0;
    } else if (currentLocation.startsWith('/locations')) {
      return 1;
    } else if (currentLocation.startsWith('/shop')) {
      return 2;
    } else if (currentLocation.startsWith('/events')) {
      return 3;
    } else if (currentLocation.startsWith('/cart')) {
      return 4;
    }
    // Default to news
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // News
        if (_canNavigate() != 0) {
          context.go(AppRoutesNames.news.path);
        }
        break;
      case 1:
        if (_canNavigate() != 1) {
          context.go(AppRoutesNames.locations.path);
        }
        break;
      case 2:
        // Shop
        if (_canNavigate() != 2) {
          context.go(AppRoutesNames.shop.path);
        }
        break;
      case 3:
        // Events
        if (_canNavigate() != 3) {
          context.go(AppRoutesNames.events.path);
        }
        break;
      case 4:
        // Cart
        if (_canNavigate() != 4) {
          context.go(AppRoutesNames.cart.path);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(),
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: parentContext.getString(label: 'bottomNavigation.news'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: parentContext.getString(label: 'bottomNavigation.locations'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: parentContext.getString(label: 'bottomNavigation.shop'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                BlocProvider.value(
                  value: sl<CartCubit>(),
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      final totalItems = state.cart.items.fold<int>(
                        0,
                        (sum, item) => sum + item.quantity,
                      );

                      if (totalItems == 0) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              totalItems.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            label: 'Cart',
            // label: parentContext.getString(label: 'bottomNavigation.cart'),
          ),
        ],
      ),
    );
  }
}
