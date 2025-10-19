import 'package:flutter/material.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Accounts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Icon(Icons.account_balance, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Add your bank & record all your bank transactions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
             Text(
              'Get payments into your bank account via QR code.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_circle_fill, color: Colors.red),
              label: const Text('Watch Video', style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            AddButton(label: 'Add Bank', onPressed: () {}), // <-- MODIFIED THIS LINE
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}