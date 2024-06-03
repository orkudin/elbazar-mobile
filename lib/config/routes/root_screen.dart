import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _buildBottomNavBarItems,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index,
            initialLocation: index == navigationShell.currentIndex),
      ),
    );
  }
}

List<BottomNavigationBarItem> get _buildBottomNavBarItems => [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.category), label: 'Categories'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), label: 'Cart'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];
