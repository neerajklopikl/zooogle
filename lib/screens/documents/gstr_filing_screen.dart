import 'package:flutter/material.dart';
import 'package:zooogle/screens/placeholder_screen.dart';

class GstrFilingScreen extends StatelessWidget {
  const GstrFilingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GSTR Filing'),
      ),
      body: ListView(
        children: [
          _buildGstrItem(context, 'GSTR-1 Summary', 'View summary of outward supplies.', const PlaceholderScreen(title: 'GSTR-1 Summary')),
          _buildGstrItem(context, 'GSTR-3B Summary', 'View summary of monthly returns.', const PlaceholderScreen(title: 'GSTR-3B Summary')),
          _buildGstrItem(context, 'Reconcile (2A/2B)', 'Match purchase data with supplier data.', const PlaceholderScreen(title: 'GSTR Reconciliation')),
          _buildGstrItem(context, 'File GSTR-1', 'Upload your outward supplies data.', const PlaceholderScreen(title: 'File GSTR-1')),
        ],
      ),
    );
  }

  Widget _buildGstrItem(BuildContext context, String title, String subtitle, Widget screen) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
    );
  }
}