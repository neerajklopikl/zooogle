import 'package:flutter/material.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class OnlineStoreScreen extends StatelessWidget {
  const OnlineStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Online Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ab India Karega business online.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                    const SizedBox(height: 4),
                    const Text('1665+ Stores created Today ✨', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'You are just one step away from creating Online Store. 🛍️',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add an item before proceeding.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AddButton(label: 'Add Item', onPressed: () {}), // <-- MODIFIED THIS LINE
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(context, 'Grow\nIncome 10x', Icons.monetization_on),
                _buildFeature(context, 'Get new\ncustomers online', Icons.group_add),
                _buildFeature(context, 'Get more\norders', Icons.shopping_bag),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, String text, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.grey.shade800, size: 30),
        ),
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }
}