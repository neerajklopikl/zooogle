import 'package:flutter/material.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class LoanAccountsScreen extends StatelessWidget {
  const LoanAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Accounts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Icon(Icons.credit_card, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Add your loan accounts on Vyapar and manage your Business Loans',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            AddButton(label: 'Add Loan Account', onPressed: () {}), // <-- MODIFIED THIS LINE
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}