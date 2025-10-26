import 'package:flutter/material.dart';
import 'package:zooogle/screens/dashboard_screen.dart';
import 'package:zooogle/screens/reports_screen.dart';
import 'package:zooogle/screens/items_screen.dart';
import '../widgets/app_nav_rail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of the main screens in your app
  static const List<Widget> _mainScreens = <Widget>[
    DashboardScreen(), // Your existing dashboard
    ReportsScreen(),   // Placeholder for Reports
    ItemsScreen(),     // Placeholder for Items
    Text('Menu'),      // Placeholder for Menu
    Text('Profile'),   // Placeholder for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // The persistent navigation rail on the left
          AppNavRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // A divider between the rail and the content
          const VerticalDivider(thickness: 1, width: 1),
          // The main content area, which changes based on selection
          Expanded(
            child: _mainScreens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
