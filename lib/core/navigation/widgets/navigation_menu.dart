import 'package:flutter/material.dart';
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

  int _getCurrentIndex() {
    if (currentLocation.startsWith('/news')) {
      return 0;
    } else if (currentLocation.startsWith('/shop')) {
      return 2;
    }
    // Default to news
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // News
        context.push(AppRoutesNames.news.path);
        break;
      case 1:
        // Locations - Disabled for now
        break;
      case 2:
        // Shop
        context.push(AppRoutesNames.shop.path);
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
            icon: Icon(Icons.shopping_cart),
            label: parentContext.getString(label: 'bottomNavigation.shop'),
          ),
        ],
      ),
    );
  }
}
