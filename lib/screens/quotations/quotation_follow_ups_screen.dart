import 'package:flutter/material.dart';

class QuotationFollowUpsScreen extends StatelessWidget {
  const QuotationFollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation Follow-ups'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.schedule, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No follow-ups scheduled.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'You can schedule follow-ups from a quotation\'s details screen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new follow-up!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
