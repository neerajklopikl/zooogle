import 'package:flutter/material.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class ManageCompaniesScreen extends StatelessWidget {
  const ManageCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Companies'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'MY COMPANIES'),
              Tab(text: 'SHARED WITH ME'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyCompaniesTab(context),
            const Center(child: Text('Companies shared with you will appear here.')),
          ],
        ),
      ),
    );
  }

  Widget _buildMyCompaniesTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Currently logged in with: 8384049914',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            child: ListTile(
              title: const Text('My Company'),
              subtitle: const Text('Last Sale Created: 12/10/2025 at 10:05 am'),
              trailing: const Icon(Icons.more_vert),
              leading: Chip(
                label: const Text('Current'),
                backgroundColor: Colors.green.shade100,
                labelStyle: TextStyle(color: Colors.green.shade800, fontSize: 12),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.restore),
                  label: const Text('Restore backup'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AddButton(label: 'Add Company', onPressed: () {}), // <-- MODIFIED THIS LINE
              ),
            ],
          ),
        ],
      ),
    );
  }
}