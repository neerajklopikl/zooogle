import 'package:flutter/material.dart';

class AppNavigationRail extends StatelessWidget {
    final int selectedIndex;
    final Function(int) onItemTapped;

    const AppNavigationRail({super.key, required this.selectedIndex, required this.onItemTapped});

    @override
    Widget build(BuildContext context) {
        return NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onItemTapped,
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color(0xFFFEFBF6),
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('My Company', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: Text('Reports')),
                NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: Text('Items')),
                NavigationRailDestination(icon: Icon(Icons.menu_outlined), selectedIcon: Icon(Icons.menu), label: Text('Menu')),
                NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
            ],
        );
    }
}