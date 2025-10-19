import 'package:flutter/material.dart';

class CashInHandScreen extends StatelessWidget {
  const CashInHandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash In-Hand'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Cash Balance', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                const Text('₹ 15.00', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Divider(),
                const Text('Transaction Details', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(
            title: const Text('Sale - Chetan'),
            subtitle: const Text('12 Oct 2025 - 10:05 AM'),
            trailing: const Text('₹ 15.00', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){}, child: const Text('Bank Transfer'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: (){}, child: const Text('Adjust Cash'))),
                ],
              ),
           ),
        ],
      ),
    );
  }
}