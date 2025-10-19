import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/providers/theme_provider.dart';
import 'package:zooogle/screens/items_screen.dart';
import 'package:zooogle/screens/reports_screen.dart';
import 'package:zooogle/screens/settings_screen.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'dashboard_screen.dart';
import '../widgets/common/app_drawer.dart';
import '../widgets/common/app_navigation_rail.dart';
import '../widgets/common/add_button.dart';
import 'new_report_screen.dart';
import 'menu_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  int _railIndex = 0;
  int _drawerIndex = 0;
  int _dashboardToggleIndex = 0;

  late final List<Widget> _bottomNavScreens;
  late final List<Widget> _desktopScreens;

  @override
  void initState() {
    super.initState();
    final dashboardScreen = DashboardScreen(onToggleChanged: _onDashboardToggleChanged);

    _bottomNavScreens = <Widget>[
      dashboardScreen,
      const Center(child: Text('GimBooks Pay Screen')),
      const SettingsScreen(),
      const Center(child: Text('Contact Us Screen')),
    ];

    _desktopScreens = <Widget>[
      dashboardScreen,
      const ReportsScreen(),
      const ItemsScreen(),
      const MenuScreen(),
      const ProfileScreen(),
    ];
  }
  
  void _navigateToCreateSale() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTransactionScreen(type: TransactionType.sale)), // Corrected
    );
  }

  void _onDashboardToggleChanged(int index) {
    setState(() {
      _dashboardToggleIndex = index;
    });
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _onRailDestinationSelected(int index) {
    setState(() {
      _railIndex = index;
    });
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    if (index == _drawerIndex) return;

    final List<Widget Function()> screenBuilders = [
      () => widget,
      () => const NewReportScreen(),
      () => const ItemsScreen(),
      () => const MenuScreen(),
      () => const ProfileScreen(),
    ];

    if (index > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screenBuilders[index]()),
      );
    } else {
        setState(() {
            _drawerIndex = index;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        if (isMobile) {
          return buildMobileLayout();
        } else {
          return buildDesktopLayout();
        }
      },
    );
  }

  Widget buildMobileLayout() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Company'),
        actions: [
          IconButton(
            // VVV THIS IS THE CORRECTED WIDGET VVV
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!isDarkMode);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: _navigateToCreateSale,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Create Invoice'),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(
        selectedIndex: _drawerIndex,
        onItemTapped: _onDrawerItemTapped,
      ),
      body: _bottomNavScreens.elementAt(_bottomNavIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment_outlined), activeIcon: Icon(Icons.payment), label: 'GimBooks Pay'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Setting'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail_outlined), activeIcon: Icon(Icons.contact_mail), label: 'Contact Us'),
        ],
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavItemTapped,
        selectedItemColor: const Color.fromARGB(255, 4, 2, 83),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: AddButton(
        label: _dashboardToggleIndex == 0 ? 'Add New Sale' : 'Add New Party',
        onPressed: _dashboardToggleIndex == 0 ? _navigateToCreateSale : () {},
        isFab: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: _railIndex,
            onItemTapped: _onRailDestinationSelected,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _desktopScreens[_railIndex],
          ),
        ],
      ),
    );
  }
}