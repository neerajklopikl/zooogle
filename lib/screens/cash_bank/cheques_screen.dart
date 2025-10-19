import 'package:flutter/material.dart';

class ChequesScreen extends StatelessWidget {
  const ChequesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cheques'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Hey! You have not added any cheques yet.",
              style: TextStyle(fontSize: 16),
            ),
             Text(
              "Any payment involving cheque appears here",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}