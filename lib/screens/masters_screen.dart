import 'package:flutter/material.dart';
import 'package:zooogle/screens/masters_list_screen.dart'; // We will create this next

class MastersScreen extends StatelessWidget {
  const MastersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masters'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildMasterCategory(
            context,
            title: 'Transaction Series',
            items: [
              'Sale Series',
              'Purchase Series',
            ],
          ),
          const SizedBox(height: 16),
          _buildMasterCategory(
            context,
            title: 'Expense Masters',
            items: [
              'Expense Categories',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterCategory(BuildContext context, {required String title, required List<String> items}) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...items.map((item) => ListTile(
                title: Text(item),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to the list screen for that specific master type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MastersListScreen(masterType: item)),
                  );
                },
              )),
        ],
      ),
    );
  }
}
