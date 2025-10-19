import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppDrawer({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFEFBF6),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFFF8E1)),
            child: Text('My Company', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          _buildDrawerItem(0, Icons.dashboard_outlined, 'Dashboard'),
          _buildDrawerItem(1, Icons.description_outlined, 'New Report'),
          _buildDrawerItem(2, Icons.inventory_2_outlined, 'Items'),
          _buildDrawerItem(3, Icons.menu_outlined, 'Menu'),
          _buildDrawerItem(4, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem(int index, IconData icon, String title) {
     return ListTile(
            leading: Icon(icon),
            title: Text(title),
            selected: selectedIndex == index,
            selectedTileColor: Colors.amber.withOpacity(0.2),
            onTap: () => onItemTapped(index),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          );
  }
}