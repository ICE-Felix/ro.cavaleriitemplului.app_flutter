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

  int _canNavigate() {
    if (currentLocation == '/news') {
      return 0;
    } else if (currentLocation == '/locations') {
      return 1;
    } else if (currentLocation == '/shop') {
      return 2;
    } else if (currentLocation == '/events') {
      return 3;
    } else if (currentLocation == '/profile') {
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
    } else if (currentLocation.startsWith('/profile')) {
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
        // Profile
        if (_canNavigate() != 4) {
          context.go(AppRoutesNames.profile.path);
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
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
