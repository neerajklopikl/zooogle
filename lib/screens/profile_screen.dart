import 'package:flutter/material.dart';
import 'package:zooogle/screens/profile/manage_companies_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _buildProfileListItem(
                  context,
                  title: 'Manage Companies',
                  icon: Icons.business_center_outlined,
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageCompaniesScreen()),
                    );
                  }
                ),
                 const Divider(height: 1, indent: 16, endIndent: 16),
                _buildProfileListItem(
                  context,
                  title: 'Account Settings',
                  icon: Icons.manage_accounts_outlined,
                  onTap: () {}
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: _buildProfileListItem(
              context,
              title: 'Logout',
              icon: Icons.logout,
              color: Colors.red,
              onTap: () {
                  // Add logout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout Successful!')),
                    );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return const Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.amber,
          child: Text('MC', style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
        SizedBox(height: 12),
        Text(
          'My Company',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'contact@mycompany.com',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileListItem(BuildContext context, {required String title, required IconData icon, Color? color, required VoidCallback onTap}) {
    final listColor = color ?? Theme.of(context).textTheme.bodyLarge?.color;
    return ListTile(
      leading: Icon(icon, color: listColor),
      title: Text(title, style: TextStyle(color: listColor)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: listColor),
      onTap: onTap,
    );
  }
}